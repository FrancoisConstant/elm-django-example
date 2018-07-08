from ede.models import Tweet


def get_tweets_search_data():
    return dict(
        tweets=[
            {
                'author_url': tweet.author.url,
                'author_name': tweet.author.name,
                'content': tweet.content,
                'searchString': "{username} {name} {content}".format(
                    username=tweet.author.username,
                    name=tweet.author.name,
                    content=tweet.content
                ).lower(),
            } for tweet in Tweet.objects.prefetch_related('author').all()
        ]
    )
