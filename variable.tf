variable "region"{
    default  = "us-east-1"
}

variable "vpc"{
    default  = "10.0.0.0/16"
}

variable "pub-subnet"{
    default = "10.0.1.0/24"
}

variable "pvt-subnet"{
    default = "10.0.2.0/24"
}

variable "fe-sg"{
    default  = "frontend-sg"
}

variable "be-sg"{
    default  = "backend-sg"
}

variable "db"{
    default = "db-sg"
}

variable "ami"{
    default = "ami-0360c520857e3138f"
}

variable "instance"{
    default  = "t2.micro"
}

