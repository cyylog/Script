package dbs

import (
	"ginskill/src/models/UserModel"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
	"log"
	"time"
)
var Orm *gorm.DB
func InitDB(){
	Orm=gormDB()
}
func InitTable(){
	err:=Orm.AutoMigrate(UserModel.New())
	if err!=nil{
		log.Fatal(err)
	}
}

func gormDB() *gorm.DB {
	dsn:="root:root@tcp(localhost:3306)/gin?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(dsn),&gorm.Config{})
	if err != nil {
		log.Fatal(err)
	}
	mysqlDB,err:=db.DB()
	if err != nil {
		log.Fatal(err)
	}
	mysqlDB.SetMaxIdleConns(5)
	mysqlDB.SetMaxOpenConns(10)
	mysqlDB.SetConnMaxLifetime(time.Second*30)
	return db
}