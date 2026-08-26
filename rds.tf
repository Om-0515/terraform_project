resource "aws_db_subnet_group" "rds" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_db_1.id, aws_subnet.private_db_2.id]
}

resource "aws_rds_cluster" "postgresql" {
  cluster_identifier     = "aurora-db-cluster"
  engine                 = "aurora-postgresql"
  database_name          = "mydb"
  master_username        = "user-om"
  master_password        = "om2002"
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
   skip_final_snapshot    = true
}


resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-instance-${count.index}"
  cluster_identifier = aws_rds_cluster.postgresql.id
  instance_class     = "db.t3.medium"
  engine             = aws_rds_cluster.postgresql.engine
}