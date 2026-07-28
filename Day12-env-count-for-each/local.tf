locals { 
    instance_name = toset(["dev","test","prod"])
  

  
      instance_types = {
    dev  = "t3.micro"
    test = "t3.micro"
    prod = "t3.micro"
  }

}
  

