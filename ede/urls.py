from django.urls import path
from . import views


urlpatterns = [
    path('', views.index, name="index"),
    path('search-tweets', view=views.search_tweets, name='search_tweets'),
    path('search-tweets.json', view=views.search_tweets_json, name='search_tweets_json'),
]
