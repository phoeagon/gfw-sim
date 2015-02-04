import encodings
import base64

ENCODE_SET={'gb2312', 'utf8'}
OPS={base64.b64encode, base64.b32encode, base64.b16encode, base64.urlsafe_b64encode}

def enum(keywords):
    ret = {a.strip() for a in keywords}
    for word in keywords:
        try:
            word = word.decode('utf8')
        except:
            pass
        try:
            word = word.decode('gbk')
        except:
            pass
        for encoding in ENCODE_SET:
            try:
                ret.add(base64.b64encode(word.encode(encoding)))
            except:
                pass
    return ret
