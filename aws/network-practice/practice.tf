# =============================================================================
# Exo 1 : C'est quoi un subnet public en vrai ?
# Etape 1 : VPC + subnet + EC2 avec IP publique         => SSH timeout
# Etape 2 : + Internet Gateway                           => SSH timeout
# Etape 3 : + route table 0.0.0.0/0 -> IGW sur le subnet => SSH OK
# =============================================================================

# -----------------------------------------------------------------------------
# Variables
# -----------------------------------------------------------------------------

# Région AWS où tout est déployé (utilisée par providers.tf)
variable "region" {
  type    = string
  default = "eu-west-3" # Paris
}

# Ton IP publique, au format CIDR /32 (= une seule adresse).
# Récupère-la avec : curl ifconfig.me
# Puis passe-la avec : terraform apply -var="my_ip=1.2.3.4/32"
variable "my_ip" {
  type        = string
  description = "Ton IP publique en /32, seule IP autorisée en SSH"
}

# Contenu de ta clé SSH PUBLIQUE (la ligne "ssh-ed25519 AAAA..." du fichier .pub).
# On passe le contenu et pas un chemin, car le fichier n'existe pas sur le runner de la CI.
# En local : dans terraform.tfvars. En CI : secret GitHub SSH_PUBLIC_KEY.
variable "ssh_public_key" {
  type        = string
  description = "Contenu de la clé SSH publique installée dans l'EC2"
}

# -----------------------------------------------------------------------------
# VPC : ton réseau privé isolé dans AWS ("ton quartier fermé")
# -----------------------------------------------------------------------------
resource "aws_vpc" "lab" {
  # Plage d'IP privées du VPC : 10.0.0.0 -> 10.0.255.255 (65 536 adresses)
  cidr_block = "10.0.0.0/16"

  # Donne un nom DNS aux instances qui ont une IP publique
  # (ec2-13-38-x-x.eu-west-3.compute.amazonaws.com)
  enable_dns_hostnames = true

  tags = { Name = "lab-vpc" }
}

# -----------------------------------------------------------------------------
# Subnet : un sous-réseau du VPC, posé dans UNE zone de disponibilité (AZ)
# Pour l'instant il n'a ni IGW ni route vers Internet => il est privé de fait.
# -----------------------------------------------------------------------------
resource "aws_subnet" "public" {
  vpc_id = aws_vpc.lab.id

  # Morceau du VPC : 10.0.1.0 -> 10.0.1.255 (256 adresses, dont 5 réservées par AWS)
  cidr_block = "10.0.1.0/24"

  # Datacenter physique dans lequel vit le subnet
  availability_zone = "${var.region}a"

  tags = { Name = "lab-public" }
}

# -----------------------------------------------------------------------------
# Security Group : le videur devant l'EC2. Il filtre donc APRES l'IGW
# -----------------------------------------------------------------------------
resource "aws_security_group" "ssh" {
  name        = "lab-ssh"
  description = "SSH depuis mon IP uniquement"
  vpc_id      = aws_vpc.lab.id

  # Entrée : seulement TON IP, seulement le port 22 (SSH), en TCP
  ingress {
    description = "SSH depuis mon IP"
    from_port   = 22 # le "from" et "to" n'a rien à voir avec l'origine ou la destination,
    to_port     = 22 # c'est seulement une plage (donc la c'est que le port 22)
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Sortie : tout est autorisé
  # protocol "-1" = tous les protocoles, ports 0 = tous les ports
  egress {
    description = "Tout en sortie"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "lab-ssh" }
}

# -----------------------------------------------------------------------------
# Key pair : enregistre ta clé SSH publique chez AWS.
# AWS la copie dans l'EC2 au démarrage, toi tu gardes la clé privée.
# -----------------------------------------------------------------------------
resource "aws_key_pair" "lab" {
  key_name   = "lab-key"
  public_key = var.ssh_public_key
}

# -----------------------------------------------------------------------------
# AMI : on demande à AWS l'image Amazon Linux 2023 la plus récente
# (data = on LIT une info existante, on ne crée rien)
# -----------------------------------------------------------------------------
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"] # uniquement les images officielles d'Amazon

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# -----------------------------------------------------------------------------
# EC2 : la machine virtuelle
# -----------------------------------------------------------------------------
resource "aws_instance" "web" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro" # petite et pas chère

  # Dans quel subnet elle vit (=> elle prend une IP privée en 10.0.1.x)
  subnet_id = aws_subnet.public.id

  # Le(s) videur(s) attaché(s) à l'instance
  vpc_security_group_ids = [aws_security_group.ssh.id]

  # Quelle clé SSH AWS installe dans l'instance
  key_name = aws_key_pair.lab.key_name

  # Demande à AWS une IP publique (choisie par AWS, change au stop/start)
  associate_public_ip_address = true

  tags = { Name = "lab-web" }
}

# -----------------------------------------------------------------------------
# Etape 2 - Internet Gateway : la porte entre le VPC et Internet.
# Elle traduit aussi IP publique <-> IP privée de l'EC2 dans les deux sens.
# Gratuite, managée par AWS, une seule par VPC.
# -----------------------------------------------------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lab.id # on "accroche" la porte à notre VPC

  tags = { Name = "lab-igw" }
}

# -----------------------------------------------------------------------------
# Etape 3 - Route table : les panneaux de direction du subnet.
# AWS y met toujours une route "10.0.0.0/16 -> local" (le trafic interne au VPC),
# on n'a pas besoin de l'écrire.
# -----------------------------------------------------------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  # "Tout ce qui n'est pas dans le VPC, envoie-le à l'IGW"
  # 0.0.0.0/0 = n'importe quelle adresse (la route la plus large, utilisée en dernier recours)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = { Name = "lab-public-rt" }
}

# Branche la route table sur le subnet.
# Sans ça, le subnet continue d'utiliser la "main route table" du VPC (juste la route local).
# C'est CETTE association qui rend le subnet public.
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------------------------
# Outputs : infos affichées après le apply
# -----------------------------------------------------------------------------
output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}

output "ssh_command" {
  value = "ssh -o ConnectTimeout=5 ec2-user@${aws_instance.web.public_ip}"
}
