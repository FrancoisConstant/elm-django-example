module Search exposing (..)

import Array
import Html exposing (Html, button, div, em, h1, h2, h3, input, li, p, span, strong, text, ul)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import List


type alias Tweet =
    { content : String
    , searchString : String -- lower case with all content
    , authorUrl : String
    , authorName : String
    }


type alias Model =
    { allTweets : Array.Array Tweet
    }


type Msg
    = GotTweets (Result Http.Error (Array.Array Tweet))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getInitialModel : Model
getInitialModel =
    Model Array.empty


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    ( getInitialModel, getTweets )


view model =
    div []
        [ renderTweets model ]


renderTweets : Model -> Html Msg
renderTweets model =
    div []
        [ h3 [] [ text "All the tweets" ]
        , model.allTweets
            |> Array.map renderTweet
            |> Array.toList
            |> div []
        ]


renderTweet : Tweet -> Html Msg
renderTweet tweet =
    li []
        [ strong [] [ text tweet.authorName ]
        , text " - "
        , span [] [ text tweet.content ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTweets (Ok newTweets) ->
            ( { getInitialModel | allTweets = newTweets }
            , Cmd.none
            )

        GotTweets (Err e) ->
            Debug.log (toString e)
                ( model, Cmd.none )


getTweets : Cmd Msg
getTweets =
    let
        url =
            "/search-tweets.json"
    in
    Http.send GotTweets (Http.get url tweetsDecoder)


tweetsDecoder : Decode.Decoder (Array.Array Tweet)
tweetsDecoder =
    Decode.at [ "tweets" ] (Decode.array tweetDecoder)


tweetDecoder : Decode.Decoder Tweet
tweetDecoder =
    Decode.map4
        Tweet
        (Decode.at [ "content" ] Decode.string)
        (Decode.at [ "search_string" ] Decode.string)
        (Decode.at [ "author_url" ] Decode.string)
        (Decode.at [ "author_name" ] Decode.string)
