from django.db import models
from ede.mixins import TimestampsMixin


class TweetAuthor(TimestampsMixin, models.Model):
    """ The one who writes the tweets (or their minion) """
    name = models.CharField(max_length=100)
    username = models.CharField(max_length=100)

    @property
    def url(self):
        """ e.g. https://twitter.com/jesus """
        return "https://twitter.com/{username}".format(username=self.username)


class Tweet(TimestampsMixin, models.Model):
    author = models.ForeignKey(to="ede.TweetAuthor", related_name="tweets", on_delete=models.CASCADE)
    content = models.TextField()
