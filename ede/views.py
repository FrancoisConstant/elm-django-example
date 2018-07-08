from django.http import JsonResponse
from django.shortcuts import render

from ede.services import get_tweets_search_data


def index(request):
    return render(request, "ede/index.html", {})


def search_tweets(request):
    """
    Search tweets
    search is handled via elm, we provide a json with all the necessary data via search_tweets_json below
    """
    return render(request, 'ede/search.html')


def search_tweets_json(request):
    """ All the tweets """
    return JsonResponse(
        data=get_tweets_search_data()
    )
