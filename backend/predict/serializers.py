from rest_framework import serializers

class PredictSerializers(serializers.Serializer):
    email = serializers.EmailField()
    user_id = serializers.CharField()
    images =  serializers.ListField(
        child = serializers.ImageField(),
        min_length = 5,
        max_length = 10
    )

    def validate_image(seft, value):
        if value.content_type not in ['image/jpeg', 'image/png']:
            raise serializers.ValidationError("Only JPG or PNG files are accepted")
        max_size = 5 * 1024 * 1024  # 5MB
        if value.size > max_size:
            raise serializers.ValidationError("Image file size must be under 5MB")
        return value