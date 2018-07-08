from django.core.management.base import BaseCommand

from ede.fixtures import load_some_random_tweets


class Command(BaseCommand):

    def handle(self, *args, **options):
        load_some_random_tweets()
