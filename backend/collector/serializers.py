from rest_framework import serializers

class ColectorSerializers(serializers.Serializer):
    action = serializers.CharField()
    article_id = serializers.CharField()