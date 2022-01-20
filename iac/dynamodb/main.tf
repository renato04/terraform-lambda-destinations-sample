resource "aws_dynamodb_table" "s3-metadata-table" {
    name           = var.dynamo_metadata_table
    billing_mode   = "PROVISIONED"
    read_capacity  = 1
    write_capacity = 1
    hash_key       = "ObjectKey"
    range_key      = "LastModifiedTS"

    attribute {
        name = "ObjectKey"
        type = "S"
    }

    attribute {
        name = "LastModifiedTS"
        type = "S"
    }

    attribute {
        name = "LastModifiedDay"
        type = "S"
    }

    global_secondary_index  {
        name               = "LastModifiedTS-index"
        hash_key           = "LastModifiedDay"
        range_key          = "ObjectKey"
        read_capacity      = "1"
        write_capacity     = "1"
        projection_type    = "ALL"
    }
}