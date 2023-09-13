#!/usr/bin/env python

import ldap3
import argparse
import logging

logger = logging.getLogger(__name__)

class LDAP(object):
    def __init__(self, usr, pwd, server, port=636):
        """
        """
        domain = '.'.join(server.split('.')[-2:])
        self.user = usr + f'@{domain}'
        self.password = pwd
        self.server = ldap3.Server(f'{server}:{port}', use_ssl=True)
        self.cnxn = None
        self.generator = None

        return

    def connect(self):
        """
        """

        self.cnxn = ldap3.Connection(self.server, self.user, self.password)
        self.cnxn.start_tls()

        try:
            self.cnxn.bind()
        except ldap3.core.exceptions.LDAPSocketOpenError:
            logging.error("Error: Could not bind to LDAP")
            return False

        return self.cnxn.bind()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('usr')
    parser.add_argument('pwd')
    parser.add_argument('ldap_server')
    parser.add_argument('ldap_port')
    args = parser.parse_args()

    if len(args.pwd) == 1:
        # This happens when the user is invalid for ssh
        print(f'Unrecognized user "{args.usr}" on this server')
        print(f'Please create new user "sudo useradd -m {args.usr}" -s /bin/bash')
        exit(1)
    else:
        print(f'Username "{args.usr}" is a recognized user on this server')

    ldap = LDAP(args.usr, args.pwd, args.ldap_server, args.ldap_port)

    if ldap.connect():
        print(f'Good LDAP Credentials for "{args.usr}"')
        exit(0)
    else:
        print("Connection to LDAP Failed")

    print(f'Continue with /etc/pam.d/sshd authentication process for "{args.usr}"')
    exit(1)
