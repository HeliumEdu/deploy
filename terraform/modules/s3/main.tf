# TODO: provision static bucket with policy
# {
#    "Version": "2012-10-17",
#    "Statement": [
#       {
#           "Sid": "AddPerm",
#           "Effect": "Allow",
#           "Principal": "*",
#           "Action": "s3:GetObject",
#           "Resource": "arn:aws:s3:::heliumedu.{{ domain_environment }}.static/*"
#       }
#    ]
# }
#
# TODO: static bucket needs CORS config
# <?xml version="1.0" encoding="UTF-8"?>
# <CORSConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
# <CORSRule>
#     <AllowedOrigin>*</AllowedOrigin>
#     <AllowedMethod>GET</AllowedMethod>
#     <MaxAgeSeconds>3000</MaxAgeSeconds>
#     <AllowedHeader>Authorization</AllowedHeader>
# </CORSRule>
# </CORSConfiguration>