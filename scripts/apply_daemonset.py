#!/usr/bin/env python

import yaml
import os
from subprocess import call
from subprocess import Popen

'''
    As Daemonset rolling update is a feature not yet implemented in K    ubernetes -> https://github.com/kubernetes/kubernetes/issues/22543
    We have to execute this script that execute following logics:
        if daemonset version is different from config file:
            delete daemonset (without deleting pods)
            create daemonset 
            delete old pods (create by previous daemonset)
            new pods will automatically created by new daeemonset config
'''

def rollingupdate(daemonset):
    with open('config/daemonsets/{}.yaml'.format(daemonset),'r') as f:

        remote = yaml.load(os.popen("kubectl get daemonset {} -o yaml".format(daemonset)).read())
        local = yaml.load(f.read())

        remote_image = remote["spec"]["template"]["spec"]["containers"][0]["image"]
        local_image = local["spec"]["template"]["spec"]["containers"][0]["image"]

        if remote_image != local_image:
            pods = os.popen("kubectl get pods -l app={} -o name".format(daemonset))
            call([
                "kubectl", "delete", "-f", 
                "config/daemonsets/{}.yaml".format(daemonset), 
                "--cascade=false"])

            call(["kubectl", "apply", "-f", 
                "config/daemonsets/{}.yaml".format(daemonset)])
            for pod in pods:
                call(["kubectl", "delete " + pod])
        else:
            print("{}: Uptodate".format(daemonset))


files = os.listdir('config/daemonsets')
for file in files:
    if ".yaml" in file or ".yml" in file:
        with open('config/daemonsets/{}'.format(file)) as config:
            daemonset = yaml.load(config.read())
            name = daemonset["metadata"]["name"]
            rc = call(["kubectl","get","daemonset/"+name])
            if 0 == rc :
                rollingupdate(name)
            else:
                call(["kubectl","apply", "-f", "config/daemonsets/" + file])
