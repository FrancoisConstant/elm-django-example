from django.shortcuts import render


def index(request):
    return render(request, "ede/index.html", {})
