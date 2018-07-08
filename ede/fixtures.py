from ede.models import TweetAuthor, Tweet


def load_some_random_tweets():
    jesus = TweetAuthor.objects.create(
        name="Jesus",
        username="jesus"
    )

    for tweet in (
        """I will be out of the office until Monday with no phone or email access. If you need immediate attention please contact my dad directly""",
        """They say abstinence is 100% effective for birth control. Tell that to my mom""",
        """YOLO!\n\nUnless you're me.""",
        """Thanks guys, but I think I'm just going to spend my birthday alone this year.""",
        """Don't listen to the shit my Dad says""",
        """Let the healing begin"""
    ):
        Tweet.objects.create(author=jesus, content=tweet)

    jim = TweetAuthor.objects.create(
        name="Jim Jefferies",
        username="jimjefferies"
    )

    for tweet in (
        """It feels like there is a World Cup camera man who's only job is to find hot girls in the crowd""",
        """If Russia wins the world cup it's fake news""",
        """If you are going to say the word cunt, you better say it with the right accent.""",
        """We would like to make it clear that Kanye West only ever worked for the Jim Jefferies Show in a freelance 
        capacity and his views do not represent the views of us, Jim Jefferies, or Comedy Central. As of today, he is 
        no longer an employee of this production.""",
        """With all this time spent protesting, when are the teachers going to learn how to shoot their guns?"""
    ):
        Tweet.objects.create(author=jim, content=tweet)
