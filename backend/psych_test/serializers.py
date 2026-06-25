from rest_framework import serializers
import re

class PsychTestSerializers(serializers.Serializer):
    prediction_id = serializers.CharField(max_length=100)
    question_id = serializers.EmailField()
    answer_value = serializers.CharField(write_only=True) #selected answer : 1(Không hài long, 2....)
