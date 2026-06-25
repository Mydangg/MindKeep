from rest_framework import serializers
import re

class UserSerializers(serializers.Serializer):
    username = serializers.CharField(max_length=100)
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate_password(seft, value):
        pattern = '(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}'
        if not re.match(pattern, value):
            raise serializers.ValidationError("Please enter a valid password")
        return value