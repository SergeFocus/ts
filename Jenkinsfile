
def File1CDD 
def versionText
def versionValue

pipeline{
    
    agent{
        label 'bdd'
        }
    
    environment{
        Storage = credentials('Storage_Trad_CiBot')
    }
 //   triggers {
   //     cron("H/5 * * * *")
     //   }

    options {
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        
        stage ('Hello World') {
            steps {
                timestamps {
                    echo 'Привет Мир!'    
                }   
            }
        }
        


    }        

def cmd(command) {
    if(isUnix()){
        sh "${command}"
    } else {
        bat "chcp 65001\n${command}"
    }
}
