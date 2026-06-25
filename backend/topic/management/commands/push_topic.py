from django.core.management.base import BaseCommand

from topic.firebase_service import upload_topics_to_firebase

class Command(BaseCommand):
    help = "Push tất cả bài viết từ news_data.py lên Firebase"

    def handle(self, *args, **options):
        upload_topics_to_firebase()
        self.stdout.write(self.style.SUCCESS("Hoàn tất push dữ liệu lên Firebase!"))
