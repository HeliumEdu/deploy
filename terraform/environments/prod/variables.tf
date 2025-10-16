variable "helium_version" {
  description = "The container version. Bumping this will trigger a deploy."
  default     = "1.12.36"
}

variable "environment" {
  description = "The environment"
  default     = "prod"
}

variable "environment_prefix" {
  description = "Prefix used for env in hostnames (empty string when `prod`)"
  default     = ""
}

variable "aws_region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "region_azs" {
  description = "Map of AZ suffixes and their index"
  default = {
    az1 = {
      suffix = "a"
      index  = "0"
    }
    az2 = {
      suffix = "b"
      index  = "1"
    }
    az3 = {
      suffix = "c"
      index  = "2"
    }
  }
}

variable "default_arch" {
  description = "The target arch of container builds"
  default     = "X86_64"
}

variable "frontend_host_count" {
  description = "The number of frontend hosts desired in the cluster"
  default     = 2
}

variable "platform_host_count" {
  description = "The number of platform hosts desired in the cluster"
  default     = 3
}

variable "db_multi_az" {
  description = "True if DB should be multi-AZ"
  default     = false
}

variable "num_cache_nodes" {
  description = "The number of cache nodes"
  default     = 1
}

variable "helium_area_code" {
  description = "The area code for the Helium phone number"
  default     = ""
}

variable "ci_area_code" {
  description = "The area code for the CI phone number"
  default     = ""
}

variable "dkim_public_key" {
  description = "The DKIM public key"
  default     = "v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAynNkRISLXgQy5Y1/NFhlRFS5pUQgiJdc/SE8sP3CLzsQ1u56XmCr3Jpt6wHs8cKxSqXxF1/Vqpf0cOHIWWGKMOqMhFJTPb+10r1xz/nzYhhHwoySLMsPvNUEIF4SV3wmXmbxfQJhgKzYj1zPNdzTY4IjdAxVfNB5/vn73zzOGI6MJfUFuE1Fo4U5Iq30ZKnxNfmz/Tdey81NxIQWNf07yCGMDsHIboa7tpMfNlmiw4HFRceX4Bdin0dzMzSIEQ5OQ/eWBIew12SgsAcDW3FSy2SNiGLLF8P8N30UCYCrofnC4dCd6K0MubyDBokQfuIJ7bYkVSeKVevO8yIO2AET3wIDAQAB"
}

### Variables defined below this point must have their defaults defined in the Terraform Workspace

variable "AWS_ACCESS_KEY_ID" {
  description = "The AWS access key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "The AWS secret access key"
}

variable "TWILIO_ACCOUNT_SID" {
  description = "The Twilio account SID"
}

variable "TWILIO_AUTH_TOKEN" {
  description = "The Twilio auth token"
}

variable "HELIUM_TWIML_HANDLER_URL" {
  description = "The URL for the Helium TwiML Bin"
}

variable "CI_TWIML_HANDLER_URL" {
  description = "The URL for the CI TwiML Bin"
}

variable "DD_API_KEY" {
  description = "The DataDog API key"
}

variable "PLATFORM_ROLLBAR_SERVER_ITEM_ACCESS_TOKEN" {
  description = "The Rollbar project server item access token"
}

variable "FIREBASE_PROJECT_ID" {
  description = "The Firebase project ID"
}

variable "FIREBASE_PRIVATE_KEY_ID" {
  description = "The Firebase private key ID"
}

variable "FIREBASE_PRIVATE_KEY" {
  description = "The Firebase private key"
}

variable "FIREBASE_CLIENT_EMAIL" {
  description = "The Firebase client email"
}

variable "FIREBASE_CLIENT_ID" {
  description = "The Firebase client ID"
}

variable "FIREBASE_CLIENT_X509_CERT_URL" {
  description = "The Firebase client cert URL"
}
