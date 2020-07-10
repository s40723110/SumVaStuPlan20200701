<?xml version="1.0" encoding="utf-8"?>
<!-- Created by Leo: http://leoeditor.com/leo_toc.html -->
<leo_file xmlns:leo="http://leoeditor.com/namespaces/leo-python-editor/1.1" >
<leo_header file_format="2"/>
<globals/>
<preferences/>
<find_panel_settings/>
<vnodes>
<v t="yen.20200703210017.1"><vh>@Settings</vh>
<v t="yen.20200703210032.1"><vh>@data qt-gui-plugin-style-sheet</vh></v>
<v t="yen.20200703210105.1"><vh>@string initial_split_orientation = horizontal</vh></v>
</v>
<v t="yen.20200703210140.1"><vh>About blogger</vh></v>
<v t="yen.20200703210247.1"><vh>Blogger 按鈕</vh>
<v t="yen.20200703210307.1"><vh>@button add_to_mblogger</vh></v>
<v t="yen.20200703210413.1"><vh>@button edit_to_mblogger</vh></v>
</v>
<v t="yen.20200703210510.1"><vh>@path ./../</vh>
<v t="yen.20200703212613.1"><vh>@path tools</vh>
<v t="yen.20200703212200.1"><vh>@edit gmail_json_to_pickle.py</vh></v>
<v t="yen.20200703212105.1"><vh>@edit blogger_json_to_pickle.py</vh></v>
</v>
<v t="yen.20200703210535.1"><vh>@path markdown</vh>
<v t="yen.20200703210618.1"><vh>@clean 20200611.md</vh>
<v t="yen.20200703210706.1"><vh>代理主機維護策略</vh></v>
<v t="leo.20200709101031.1"><vh>3060558558339637160</vh></v>
</v>
<v t="leo.20200709101245.1"><vh>@clean 0709.md</vh>
<v t="leo.20200709101245.2"><vh>雞雞雞</vh></v>
<v t="leo.20200709101400.1"><vh>4492024764582240007</vh></v>
</v>
</v>
</v>
</vnodes>
<tnodes>
<t tx="leo.20200709101031.1"></t>
<t tx="leo.20200709101245.1">@language md
---
Title: 代理主機維護策略
Date: 2020-06-11 11:00
Category: Network
Tags: Proxy
Slug: dfhdgdjdjfjdj
Author: yen
---

昨天又失去一台 HP 代理主機, 也就是編號 42 的 Squid Proxy Server. 因此目前只剩下 4, 53 與 69 等三台.

&lt;!-- PELICAN_END_SUMMARY --&gt;

@others</t>
<t tx="leo.20200709101245.2">雙協定支援代理主機的需求
----

也許大家會存疑, 機械設計科系為何需要自行安裝維護網路代理主機？假如根據學校多年前回覆, 之所以拆掉校級的代理主機設置, 原因是聯外頻寬已經很足夠, 因此不需要網路代理主機.

但是, 這種假設是, 系上的 IPv4 數量足夠, 而大部分的外部伺服器都已經支援 IPv6, 但是對於平日電腦總數量超過 300 台的機械設計系, 希望上課時讓每一位學員都能將課程資料存取於 Github.com, 這兩個條件都不存在.

因此, 從電腦輔助設計室上課的需求來看, 採用 IPv4 NAT 的模式, 並無足夠的頻寬讓 至少 50 台電腦快速直接對 Github.com 連線, 而如眾所知, Github.com 目前尚不支援 IPv6 網路協定.

因此, 2-3 台能夠同時支援 IPv4 與 IPv6 網路協定的代理主機, 似乎是可行的方案之一.

維護全時運作主機的可能方案
----

假如以電腦輔助設計室每週 40 堂課計算, 其中只有至多 14 堂課需要使用網路代理主機, 理論上並沒有必要全時讓這些代理主機運作, 而只要維持一台連內 (69), 一台連外 (4), 其餘的 IPv4 伺服器 IP 位址, 可以交由每班中至多 5 個分組的組長, 以虛擬主機 bridged 網路的方式各自管理分組中的代理主機, 其中可能的編號將有 (24, 32, 34, 39, 42）等五台.

其中, 因為在上學期的課程有大一的計算機程式與大二的電腦輔助設計實習課程, 而下學期的課程則有大一的網際內容管理與大二的協同產品設計實習, 正好可以在各課程中安排學長與學弟妹共同維護這五台代理主機的互動傳承內容.

Squid 代理主機的安裝
----

以 Ubuntu 20.04 伺服器主機為例, 安裝 Squid Proxy 伺服器:

sudo apt install squid

接下來, 利用 /etc/squid/squid.conf 進行配置:

&lt;pre class="brush: jscript"&gt;
# 定義可以連線電腦網路位置範圍或特定 IP
acl cad_lab src 192.130.17.0/24
acl cad_lab src 192.127.237.33
acl cad_lab src 2001:288::/64

# 定義可以連線通過的埠號
acl SSL_ports port 443
acl Safe_ports port 80 # http
acl Safe_ports port 88
acl Safe_ports port 89
 
#acl Safe_ports port 21 # ftp
acl SSL_ports port 8843
acl SSL_ports port 5443
acl SSL_ports port 8443
acl Safe_ports port 8443
 
acl SSL_ports port 9443
acl Safe_ports port 9443
 
acl SSL_ports port 22
acl Safe_ports port 22
 
acl Safe_ports port 443 # https
acl Safe_ports port 1025-65535 # unregistered ports
acl Safe_ports port 280 # http-mgmt
acl Safe_ports port 488 # gss-http
acl Safe_ports port 591 # filemaker
acl Safe_ports port 777 # multiling http
acl CONNECT method CONNECT

# 除了前面定義的安全埠號外, 一律拒絕連線
# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# 除了前面定義的安全埠號外, 一律不准連線
# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports
 
# 只允許前面定義的網路 IP 電腦連線, 其餘一律禁止
http_access allow cad_lab
http_access deny all
# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager
 
#http_access allow localnet
http_access allow localhost
 
# And finally deny all other access to this proxy
http_access deny all
 
# Squid normally listens to port 3128
http_port 3128
 
#cache_dir ufs /var/spool/squid 100 16 256
icp_port 3130
icp_access allow all
 
cache_dir ufs /var/spool/squid 2000 16 256
cache_peer 192.130.17.4 sibling 3128 3130
cache_peer 192.130.17.42 sibling 3128 3130
cache_peer 192.130.17.53 sibling 3128 3130

 
#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern (Release|Packages(.gz)*)$ 0 20% 2880
refresh_pattern . 0 20% 4320

max_filedesc 40960
cache_mem 4000 MB
&lt;/pre&gt;

修改 /etc/squid/squid.conf 後, 以:

sudo systemctl restart squid 重新啟動.

假如要讓 Virtualbox 虛擬主機與 Windows 10 host 啟動開啟虛擬代理主機, 可以設定使用 [VBoxVmService], 但是 5.X 的 Virtualbox 必須與 VBoxVmService  5.X 版配合, 而 6.X 的版本也必須互動升級配置.

[VBoxVmService]: https://github.com/onlyfang/VBoxVmService

後記:

42 是一台 HP ML 30 gen9 的機器,  2017 安裝的 Ubuntu 在前幾天停止運作後, 直接將 Host 裝上 Win 10, 因無法從 USB 安裝, 只能用 blueray  dvd 重新安裝, 然後外部設為 39, 然後將虛擬 proxy 伺服器設為 42,  目前仍然加入服役中.
</t>
<t tx="leo.20200709101400.1"></t>
<t tx="yen.20200703210017.1"></t>
<t tx="yen.20200703210032.1">QTreeWidget {
    /* These apply to the selected item, but not to editing items.*/
    background-color: #ffffec; /* Leo's traditional tree color */
    selection-color: black; /* was white */
    selection-background-color: lightgrey;
    /* font-family: SansSerif; */
    /*font-family: DejaVu Sans Mono;*/
    font-family:YaHei Mono;
    /* 標題字型大小設定 */
    font-size: 20px;
    font-weight: normal; /* normal,bold,100,..,900 */
    font-style: normal; /* normal, italic,oblique */
 }

/* Headline edit widgets */
QTreeWidget QLineEdit {
    background-color: cornsilk;
    selection-color: white;
    selection-background-color: blue;
    /*font-family: DejaVu Sans Mono;*/    
    font-family:YaHei Mono;
    /* 沒有特別對應字型大小 */
    font-size: 20px;
    font-weight: normal; /* normal,bold,100,..,900 */
    font-style: normal; /* normal, italic,oblique */
}

/* The log panes */
QTextEdit {
    background-color: #f2fdff;
    selection-color: red;
    selection-background-color: blue;
    /* font-family: Courier New; */
    font-family:YaHei Mono;
    /* log font 大小 */
    font-size: 20px;
    font-weight: normal; /* normal,bold,100,..,900 */
    font-style: normal; /* normal, italic,oblique */
}

/* The body pane */
QTextEdit#richTextEdit {
    background-color: #fdf5f5; /* A kind of pink. */
    selection-color: white;
    selection-background-color: red;
    /*font-family: DejaVu Sans Mono;*/
    /* font-family: Courier New; */
    font-family:YaHei Mono;
    /* 內文字型大小 */
    font-size: 20px;
    font-weight: normal; /* normal,bold,100,..,900 */
    font-style: normal; /* normal,italic,oblique */
}

QLabel {
    font-family:YaHei Mono;'CherryPy', 'pytz', 'mako', 'beautifulsoup4', 'pymysql', 'peewee'
    /* 下方的 Minibuffer 標題字型大小 */
    font-size: 20px;
    font-weight: normal; /* normal,bold,100,..,900 */
    font-style: normal; /* normal,italic,oblique */
}

/* Editor labels */
QLineEdit#editorLabel {
    background-color: #ffffec;
    font-family:YaHei Mono;
    /* 沒有直接對應字型大小 */
    font-size: 20px;
    font-weight: normal; /* normal,bold,100,..,900 */
    font-style: normal; /* normal,italic,oblique */
    border: 2px;
    margin: 2px;
}</t>
<t tx="yen.20200703210105.1">horizontal: body pane to the left
vertical: body pane on the botton</t>
<t tx="yen.20200703210140.1">try to integrate pelican with blogger
    
需要安裝兩個程式庫
    
    pip install google-api-python-client oauth2client
    
OAuth 2.0 client IDs 程式類別選擇 other
    
使用者完成 client_secrets.json 設定後, 必須將檔案存在倉儲目錄外部


    
</t>
<t tx="yen.20200703210247.1"></t>
<t tx="yen.20200703210307.1">@language python
from markdown import markdown
from oauth2client import client
#from googleapiclient import sample_tools
import os
# 配合使用 credential token
import pickle
from googleapiclient.discovery import build
#from google_auth_oauthlib.flow import InstalledAppFlow
#from google.auth.transport.requests import Request

os.environ['TZ'] = 'Asia/Taipei'
with open('./../../client_secrets.dat', 'rb') as credentials_dat:
    credentials = pickle.load(credentials_dat)
service = build('blogger', 'v3', credentials=credentials)

def get_cat_tag_content(data):
    # 請注意, 因為 data 來自 .md 的檔案 內容, 第1行為 ---
    # 用跳行符號分割
    data_list = data.split("\n")
    #第 2 行為 title
    title= data_list[1]
    #第 4 行為 category
    category = data_list[3]
    #第 5 行為 tags
    tags = data_list[4]
    # 有多項資料的 content 型別為數列
    # 再將第 9 行之後的資料數列串回成以跳行隔開的資料
    content = "\n".join(data_list[8:])
    # 先將截斷摘要與內文的 pelican md 檔按符號, 換成 Blogger 的 &lt;!--more--&gt;
    content = content.replace('&lt;!-- PELICAN_END_SUMMARY --&gt;', '&lt;!--more--&gt;')
    # 接著若內容有 ~~~python 與 ~~~ 則換成 Wordpress 格式
    #content = content.replace('~~~python', '[code lang="python"]')
    #content = content.replace('~~~', '[/code]')
    return title, category, tags, content

# 從目前所在節點的 body pan 中取出類別, tags 以及文章內容
# p.h 為 @clean filename.md
# 因為要使用 @clean 節點掛上為後的 blogger post_id, 因此改為讀 .md 檔案
md_filename = p.h.split(" ")[1]
with open(md_filename, 'r', encoding="utf-8") as content_file:
    md_content = content_file.read()
# title_str, category_str, tags_str, content = get_cat_tag_content(p.b)
title_str, category_str, tags_str, content = get_cat_tag_content(md_content)
category = category_str.split(":")[1]
tags = tags_str.split(":")[1].split(",")
tags.append(category)
# title 是一個單獨的字串
title = title_str.split(":")[1]
# 將 markdown 格式 content 轉為 html
content = markdown(content)
# 以下處理 content 的 &lt;h2&gt; 標題
content = content.replace("&lt;h2&gt;", "&lt;h2&gt;&lt;font size='4'&gt;")
content = content.replace("&lt;/h2&gt;", "&lt;/font&gt;&lt;/h2&gt;")
# g.es(content)

try:
    '''
    users = service.users()
    # 取得使用者 profile 資料
    user = users.get(userId='self').execute()
    print('網誌名稱: %s' % user['displayName'])
    '''
    blogs = service.blogs()
    # 取得使用者所建立網誌名稱
    blogs = blogs.listByUser(userId='self').execute()
    # post_id is now blogs["items"][0]["id"]
    #blog_id = blogs["items"][0]["id"]
    blog_id = "8899497896714682712"
    #for blog in blogs['items']:
        #print(blog['name'], blog['url'])
    posts = service.posts()
    # 新增網誌 post 時, 需要 post_id
    body = {
    "kind": "blogger#post",
    "id": blog_id,
    "title": title,
    # 利用 markdown 函式, 將 .md 的內文轉為 html, 作為 Blogger 的文章內容
    "content": content,
    "labels": tags
    }
    insert = posts.insert(blogId=blog_id, body=body)
    posts_doc = insert.execute()
    post_id = posts_doc["id"]
    #print(posts_doc)
    # 改用 credential token 後不會產生 blogger.dat
    #os.remove("blogger.dat")
    # 利用最後的 child 節點來儲存 post_id
    to_save_post_id = p.insertAsLastChild()   
    # 改為內文為空的節點, id 直接標在 head 標題 
    to_save_post_id.b = ""
    to_save_post_id.h = post_id
    # 因為新增節點, commander 必須 redraw
    c.redraw()
    g.es("post_id 為", post_id)
    g.es("已經將資料送往 MBlogger!")
except(client.AccessTokenRefreshError):
    g.es("error")

</t>
<t tx="yen.20200703210413.1">@language python
from markdown import markdown
from oauth2client import client
#from googleapiclient import sample_tools
import os
# 配合使用 credential token
import pickle
from googleapiclient.discovery import build
#from google_auth_oauthlib.flow import InstalledAppFlow
#from google.auth.transport.requests import Request

os.environ['TZ'] = 'Asia/Taipei'
with open('./../../yen_gm_blogger_token.dat', 'rb') as credentials_dat:
    credentials = pickle.load(credentials_dat)
service = build('blogger', 'v3', credentials=credentials)

def get_cat_tag_content(data):
    # 請注意, 因為 data 來自 .md 的檔案 內容, 第1行為 ---
    # 用跳行符號分割
    data_list = data.split("\n")
    #第 2 行為 title
    title= data_list[1]
    #第 4 行為 category
    category = data_list[3]
    #第 5 行為 tags
    tags = data_list[4]
    # 有多項資料的 content 型別為數列
    # 再將第 9 行之後的資料數列串回成以跳行隔開的資料
    content = "\n".join(data_list[8:])
    # 先將截斷摘要與內文的 pelican md 檔按符號, 換成 Blogger 的 &lt;!--more--&gt;
    content = content.replace('&lt;!-- PELICAN_END_SUMMARY --&gt;', '&lt;!--more--&gt;')
    # 接著若內容有 ~~~python 與 ~~~ 則換成 Wordpress 格式
    #content = content.replace('~~~python', '[code lang="python"]')
    #content = content.replace('~~~', '[/code]')
    return title, category, tags, content

# 從目前所在節點的 body pan 中取出類別, tags 以及文章內容
# p.h 為 @clean filename.md
# 因為要使用 @clean 節點掛上為後的 blogger post_id, 因此改為讀 .md 檔案
md_filename = p.h.split(" ")[1]
with open(md_filename, 'r', encoding="utf-8") as content_file:
    md_content = content_file.read()
# title_str, category_str, tags_str, content = get_cat_tag_content(p.b)
title_str, category_str, tags_str, content = get_cat_tag_content(md_content)
category = category_str.split(":")[1]
tags = tags_str.split(":")[1].split(",")
tags.append(category)
# title 是一個單獨的字串
title = title_str.split(":")[1]
# 將 markdown 格式 content 轉為 html
content = markdown(content)
# 以下處理 content 的 &lt;h2&gt; 標題
content = content.replace("&lt;h2&gt;", "&lt;h2&gt;&lt;font size='4'&gt;")
content = content.replace("&lt;/h2&gt;", "&lt;/font&gt;&lt;/h2&gt;")
# g.es(content)

try:
    blogs = service.blogs()
    # 取得使用者所建立網誌名稱
    blogs = blogs.listByUser(userId='self').execute()
    #blog_id = blogs["items"][0]["id"]
    blog_id = "7949497010793271992"
    # 設法取得原 post 的 id
    postid_outline = p.getLastChild()
    # 直接從標題取得 post 的 id 號碼
    post_id = postid_outline.h
    posts = service.posts()
    # 更新網誌文章時的 body
    body = {
    "kind": "blogger#post",
    "title": title,
    "content": content
    }
    # need to save postId to outline head
    update = posts.update(blogId=blog_id, postId=post_id, body=body, publish=True)
    update_doc = update.execute()
    # 使用 credential token 後, 無需刪除 blogger.dat
    #os.remove("blogger.dat")
    g.es("post_id 為", post_id)
    g.es("已經將更新資料送往 M Blogger!")
except(client.AccessTokenRefreshError):
    g.es("error")
</t>
<t tx="yen.20200703210510.1"></t>
<t tx="yen.20200703210535.1"></t>
<t tx="yen.20200703210618.1">@language md
---
Title: 代理主機維護策略
Date: 2020-06-11 11:00
Category: Network
Tags: Proxy
Slug: stratege-for-proxy-servers
Author: yen
---

昨天又失去一台 HP 代理主機, 也就是編號 42 的 Squid Proxy Server. 因此目前只剩下 4, 53 與 69 等三台.

&lt;!-- PELICAN_END_SUMMARY --&gt;

@others</t>
<t tx="yen.20200703210706.1">雙協定支援代理主機的需求
----

也許大家會存疑, 機械設計科系為何需要自行安裝維護網路代理主機？假如根據學校多年前回覆, 之所以拆掉校級的代理主機設置, 原因是聯外頻寬已經很足夠, 因此不需要網路代理主機.

但是, 這種假設是, 系上的 IPv4 數量足夠, 而大部分的外部伺服器都已經支援 IPv6, 但是對於平日電腦總數量超過 300 台的機械設計系, 希望上課時讓每一位學員都能將課程資料存取於 Github.com, 這兩個條件都不存在.

因此, 從電腦輔助設計室上課的需求來看, 採用 IPv4 NAT 的模式, 並無足夠的頻寬讓 至少 50 台電腦快速直接對 Github.com 連線, 而如眾所知, Github.com 目前尚不支援 IPv6 網路協定.

因此, 2-3 台能夠同時支援 IPv4 與 IPv6 網路協定的代理主機, 似乎是可行的方案之一.

維護全時運作主機的可能方案
----

假如以電腦輔助設計室每週 40 堂課計算, 其中只有至多 14 堂課需要使用網路代理主機, 理論上並沒有必要全時讓這些代理主機運作, 而只要維持一台連內 (69), 一台連外 (4), 其餘的 IPv4 伺服器 IP 位址, 可以交由每班中至多 5 個分組的組長, 以虛擬主機 bridged 網路的方式各自管理分組中的代理主機, 其中可能的編號將有 (24, 32, 34, 39, 42）等五台.

其中, 因為在上學期的課程有大一的計算機程式與大二的電腦輔助設計實習課程, 而下學期的課程則有大一的網際內容管理與大二的協同產品設計實習, 正好可以在各課程中安排學長與學弟妹共同維護這五台代理主機的互動傳承內容.

Squid 代理主機的安裝
----

以 Ubuntu 20.04 伺服器主機為例, 安裝 Squid Proxy 伺服器:

sudo apt install squid

接下來, 利用 /etc/squid/squid.conf 進行配置:

&lt;pre class="brush: jscript"&gt;
# 定義可以連線電腦網路位置範圍或特定 IP
acl cad_lab src 192.130.17.0/24
acl cad_lab src 192.127.237.33
acl cad_lab src 2001:288::/64

# 定義可以連線通過的埠號
acl SSL_ports port 443
acl Safe_ports port 80 # http
acl Safe_ports port 88
acl Safe_ports port 89
 
#acl Safe_ports port 21 # ftp
acl SSL_ports port 8843
acl SSL_ports port 5443
acl SSL_ports port 8443
acl Safe_ports port 8443
 
acl SSL_ports port 9443
acl Safe_ports port 9443
 
acl SSL_ports port 22
acl Safe_ports port 22
 
acl Safe_ports port 443 # https
acl Safe_ports port 1025-65535 # unregistered ports
acl Safe_ports port 280 # http-mgmt
acl Safe_ports port 488 # gss-http
acl Safe_ports port 591 # filemaker
acl Safe_ports port 777 # multiling http
acl CONNECT method CONNECT

# 除了前面定義的安全埠號外, 一律拒絕連線
# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# 除了前面定義的安全埠號外, 一律不准連線
# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports
 
# 只允許前面定義的網路 IP 電腦連線, 其餘一律禁止
http_access allow cad_lab
http_access deny all
# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager
 
#http_access allow localnet
http_access allow localhost
 
# And finally deny all other access to this proxy
http_access deny all
 
# Squid normally listens to port 3128
http_port 3128
 
#cache_dir ufs /var/spool/squid 100 16 256
icp_port 3130
icp_access allow all
 
cache_dir ufs /var/spool/squid 2000 16 256
cache_peer 192.130.17.4 sibling 3128 3130
cache_peer 192.130.17.42 sibling 3128 3130
cache_peer 192.130.17.53 sibling 3128 3130

 
#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp: 1440 20% 10080
refresh_pattern ^gopher: 1440 0% 1440
refresh_pattern -i (/cgi-bin/|\?) 0 0% 0
refresh_pattern (Release|Packages(.gz)*)$ 0 20% 2880
refresh_pattern . 0 20% 4320

max_filedesc 40960
cache_mem 4000 MB
&lt;/pre&gt;

修改 /etc/squid/squid.conf 後, 以:

sudo systemctl restart squid 重新啟動.

假如要讓 Virtualbox 虛擬主機與 Windows 10 host 啟動開啟虛擬代理主機, 可以設定使用 [VBoxVmService], 但是 5.X 的 Virtualbox 必須與 VBoxVmService  5.X 版配合, 而 6.X 的版本也必須互動升級配置.

[VBoxVmService]: https://github.com/onlyfang/VBoxVmService

後記:

42 是一台 HP ML 30 gen9 的機器,  2017 安裝的 Ubuntu 在前幾天停止運作後, 直接將 Host 裝上 Win 10, 因無法從 USB 安裝, 只能用 blueray  dvd 重新安裝, 然後外部設為 39, 然後將虛擬 proxy 伺服器設為 42,  目前仍然加入服役中.
</t>
<t tx="yen.20200703212613.1"></t>
</tnodes>
</leo_file>
