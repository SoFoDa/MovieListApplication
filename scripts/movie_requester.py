from lxml import html
import requests
import time

def scrape_greatest_films():
    years = {}
    for i in range(1925, 2019):
        print('Year: ' + str(i))
        page = requests.get('https://www.filmsite.org/' + str(i) + '.html')
        tree = html.fromstring(page.content)
        boxes = None
        # don't include top header
        length = len(tree.xpath('//blockquote/table/tr')) - 1
        start = 2
        titles = []
        for j in range(start, start+length):
            try:
                boxes = tree.xpath('//blockquote/table/tr[' + str(j) + ']/td[2]/p[2]/font/strong//text()')
            except IndexError:
                print('index error')
            if (len(boxes) == 0):
                boxes = tree.xpath('//blockquote/table/tr[' + str(j) + ']/td[2]/p[2]/font/b/a//text()')
                if (len(boxes) == 0):
                    boxes = tree.xpath('//blockquote/table/tr[' + str(j) + ']/td[2]/p[2]/font/b//text()')
                    if (len(boxes) == 0):
                        boxes = tree.xpath('//blockquote/table/tr[' + str(j) + ']/td[2]/font[1]/strong//text()')
                        if (len(boxes) == 0):
                            boxes = tree.xpath('//blockquote/table/tr[' + str(j) + ']/td[2]/p/font/strong//text()')
                            if (len(boxes) == 0):
                                print('missing check')
                            # /html/body/div[2]/blockquote/table/tbody/tr[6]/td[2]/p/font/strong//text()
            if (len(boxes)>0):
                value = boxes[0].split('(')
                if (value != ''):
                    title = value[0][:(len(value[0])-1)]
                    titles.append(title)
        years[i] = titles
        time.sleep(0.25)
    print(years)


if __name__ == "__main__":
    scrape_greatest_films()
    