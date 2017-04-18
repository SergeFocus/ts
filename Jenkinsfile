
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
        
        stage ('Загрузка с хранилища и обновление базы') {
            steps {
                timestamps {
                    script {
                   File1CDD = "F:/mitest/workspace/1c_trade_bdd" 
                   versionText  =  readFile encoding: 'UTF-8', file: 'src/cf/VERSION'
                   versiversionValuepnValue =  (versionText =~ /<VERSION>(.*)<\/VERSION>/)[0][1]
                   }
                     cmd("chcp 65001\n deployka loadrepo   \"/FF:/mitest/workspace/1c_trade_bdd\" \"F:/mitest/workspace/storage_trade\" -storage-user ci-bot -storage-pwd password -v8version 8.3.10")
                //   cmd("chcp 65001\n deployka loadrepo \"/F${File1CDD}\" \"F:/mitest/workspace/storage_trade\" -storage-user ${env.StorageUser} -storage-pwd ${env.StoragePwd} -v8version 8.3.10 -v8version 8.3.10 -storage-ver ${versionValue} ")
                   cmd("deployka dbupdate \"/F${File1CDD}\" -allow-warnings -v8version 8.3.10\"")
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
