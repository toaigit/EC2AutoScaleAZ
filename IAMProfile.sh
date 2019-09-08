aws iam create-role --role-name EC2-Instance-Profile --assume-role-policy-document file://EC2-Trust.json
aws iam put-role-policy --role-name EC2-Instance-Profile --policy-name EC2-Permissions --policy-document file://EC2-Permissions.json
aws iam create-instance-profile --instance-profile-name EC2-Instance-Profile
aws iam add-role-to-instance-profile --instance-profile-name EC2-Instance-Profile --role-name EC2-Instance-Profile
