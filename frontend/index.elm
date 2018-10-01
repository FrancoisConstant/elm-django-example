module Search exposing (..)

import Array
import Html exposing (Html, beginnerProgram, br, button, div, em, h1, h2, h3, input, p, span, text)
import Html.Attributes exposing (autofocus, class, href, maxlength, placeholder)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import List
import Regex


type alias Tweet =
    { content : String
    , searchString : String -- lower case with all content
    , authorUrl : String
    , authorName : String
    }


type alias Model =
    { search : String
    , allTweets : Array.Array Tweet
    , resultTweets : Array.Array Tweet
    }


type Msg
    = MsgSearch String
    | GotTweets (Result Http.Error (Array.Array Tweet))


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


getInitialModel : Model
getInitialModel =
    Model "" Array.empty Array.empty


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



--view : Model -> Html Msg


view model =
    div []
        [ renderSearchBar model
        , renderTweets model
        ]


renderSearchBar : Model -> Html Msg
renderSearchBar model =
    div [ class "search" ]
        [ input
            [ placeholder "search some tweets"
            , autofocus True
            , onInput MsgSearch
            ]
            []
        ]


renderTweets : Model -> Html Msg
renderTweets model =
    if model.search == "" then
        div [ class "message" ] [ p [] [ text "No tweet found" ] ]
    else if Array.length model.resultTweets > 0 then
        div []
            [ div [ class "message" ]
                [ p []
                    [ text (toString (Array.length model.resultTweets) ++ " results for \"" ++ model.search ++ "\"")
                    ]
                ]
            , model.resultTweets
                |> Array.map renderTweet
                |> Array.toList
                |> div []
            ]
    else
        div [ class "message" ]
            [ p [] [ text ("No results for \"" ++ model.search ++ "\"") ]
            ]


renderTweet : Tweet -> Html Msg
renderTweet tweet =
    div []
        [ h2 [] [ text tweet.content ]
        , h3 [] [ text tweet.authorName ]
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MsgSearch newSearch ->
            searchTweets model newSearch

        GotTweets (Ok newTweets) ->
            ( { getInitialModel | allTweets = newTweets }
            , Cmd.none
            )

        GotTweets (Err e) ->
            Debug.log (toString e)
            ( model, Cmd.none )


searchTweets : Model -> String -> ( Model, Cmd Msg )
searchTweets model search =
    let
        newModel =
            { model | search = search, resultTweets = filterTweets model.allTweets search }
    in
    ( newModel, Cmd.none )


filterTweets : Array.Array Tweet -> String -> Array.Array Tweet
filterTweets allTweets search =
    if search == "" then
        Array.empty
    else
        allTweets
            |> Array.filter (\tweet -> String.contains (String.toLower search) tweet.searchString)
            |> Array.slice 0 22


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
