echo ������ȫ����
Netsh IPsec static add policy name = APU��ȫ����

echo ����ɸѡ������ֹ�Ĳ���
Netsh IPsec static add filteraction name = stop action = block

echo ����ɸѡ��������Ĳ���
Netsh IPsec static add filteraction name = open action = permit

echo ����һ��ɸѡ�����Է��ʵ��ն��б�
Netsh IPsec static add filterlist name = �ɷ��ʵ��ն��б�
Netsh IPsec static add filter filterlist = �ɷ��ʵ��ն��б� srcaddr = 203.86.32.248 dstaddr = me dstport = 3389 description = ����1���� protocol = TCP mirrored = yes

echo ����һ��ɸѡ�����Է��ʵ��ն��б�
Netsh ipsec static add filter filterlist = �ɷ��ʵ��ն��б� Srcaddr = 203.86.31.0 srcmask=255.255.255.0 dstaddr = 60.190.145.9 dstport = 0 description = ����2���� protocol =any mirrored = yes

echo �������Թ���
Netsh ipsec static add rule name = �ɷ��ʵ��ն˲��Թ��� Policy = APU��ȫ���� filterlist = �ɷ��ʵ��ն��б� filteraction = stop

echo �������
netsh ipsec static set policy name = APU��ȫ���� assign = y
pause