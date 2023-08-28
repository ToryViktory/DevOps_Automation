import requests
import json
from bs4 import BeautifulSoup

def get_page_content(city,event_data="today"):
    baseurl = "https://afisha.yandex.ru/"
    full_url = ("{base}{city}/concert?date={event_data}&period=1").format(base=baseurl,city=city,event_data=event_data)
    headers = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET',
    'Access-Control-Allow-Headers': 'Content-Type'
    }
    req = requests.get(full_url, headers)
    soup = BeautifulSoup(req.content, 'html.parser')
    events_info=None
    counter = 0
    events_list = soup.find_all("div",{"class":"i-react event-card-react i-bem"})
    for event in events_list:
        tmp_dict = {}
        data = json.loads(event.attrs['data-bem'])

        tmp_dict = dict([('title', data['event-card-react']['props']['title']), 
        ('event_date', data['event-card-react']['props']['additionalInfo']),
        ('place', (('title', data['event-card-react']['props']['place']['title']), ('address', data['event-card-react']['props']['place']['address']))),
        ('link',data['event-card-react']['props']['link']),
        ('ticketsPrice',data['event-card-react']['props']['ticketsPrice'])])

        events_info.update({counter: tmp_dict})
        counter=counter+1

    return events_info

def save_content(dest_file,content):
    with open(dest_file, 'w', encoding="utf-8") as dest:
        json.dump(content, dest, indent=4, ensure_ascii=False)

if __name__ == "__main__":
    city = "saint-petersburg"
    event_data = "2023-08-30"
    dest_file = ("concerts_{city}_{data}.json").format(city=city,data=event_data)

    content = get_page_content(city,event_data)
    if content is None:
        print("No data found")
    else:
        save_content(dest_file,content)
