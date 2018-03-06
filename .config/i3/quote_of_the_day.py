import urllib.request

if __name__ == '__main__':
	fp = urllib.request.urlopen("http://quotesondesign.com/wp-json/posts?filter[orderby]=rand&filter[posts_per_page]=1")
	mybytes = fp.read()

	mystr = mybytes.decode("utf8")
	fp.close()

	x = mystr
	auther = x.split('title":"')[1].split('"')[0]
	quote = x.split('content":"<p>')[1].split('<\/p>')[0]
	output='{}: "{}"'.format(auther, quote)
	print(output)
