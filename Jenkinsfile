#!/usr/bin/env groovy

/* Load the latest version of our Shared Library defined here:
 *  https://github.com/jenkins-infra/pipeline-library.git
 */
@Library('pipeline-library@master') _

properties([
    buildDiscarder(logRotator(numToKeepStr: '96')),
    pipelineTriggers([[$class:"SCMTrigger", scmpoll_spec:"H/10 * * * *"]]),
])

String sshk8skey

/* Depending on environment, adjust k8s cluster settings */
if (infra.isTrusted()) {
    env.PREFIX='prod'
    env.LOCATION='eastus'
    env.ENV='production'
    sshk8skey='production-ssh-k8s'
}
else {
    env.PREFIX='infraci'
    env.ENV='staging'
    env.LOCATION='eastus'
    sshk8skey='staging-ssh-k8s'
}

try {
    node {
        checkout scm
        def myEnv
        stage('Init Docker'){
            deleteDir()
            checkout scm
            myEnv = docker.build('k8s_env:latest')
        }
        myEnv.withRun(){
            stage('Init'){
                deleteDir()
                checkout scm
                sshagent([sshk8skey]) {
                    sh 'make init'
                }
                stash includes: '**', name: 'k8s-init'
            }

            stage('Test'){
                deleteDir()
                unstash 'k8s-init'
                sh 'make test'
            }
        }
    }

    stage('Review') {
    /* Inside of a pull request or if executing a Multibranch Pipeline it
    * is acceptable to proceed without any review of the planned
    * Pipeline will be using a non-Multibranch Pipeline
    */
        if (infra.isTrusted()) {
            timeout(30) {
            input message: "Apply the planned updates to ${k8sPrefix}mgmt.${k8sLocation}.cloudapp.azure.com?", ok: 'Apply'
            }
        }
    }

    stage('Deploy'){
        node{
            deleteDir()
            unstash 'k8s-init'
            sh 'make apply'
        }
    }
}
finally {
    node{
        deleteDir()
        unstash 'k8s-init'
        sh 'make clean'
    }
}
