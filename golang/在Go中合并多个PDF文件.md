##### 在Go中合并多个PDF文件

> PDF文件是静态格式，因此非常适合共享而不是编辑。如果您要合并多个PDF文件，则不是剪切和粘贴的情况-谁愿意花时间去做呢？相反，您可以使用以下API在Go中合并多达十个PDF文件，从而改善文档的组织结构并保留每个文件的格式。

**要运行该操作，您只需要按照要在以下代码中放入文件的顺序输入文件：**

~~~go
package main
import (
     "fmt"
     "bytes"
     "mime/multipart"
     "os"
     "path/filepath"
     "io"
     "net/http"
     "io/ioutil"
)
func main() {
url := "https://api.cloudmersive.com/convert/merge/pdf/multi"
     method := "POST"
payload := &bytes.Buffer{}
     writer := multipart.NewWriter(payload)
     file, errFile1 := os.Open("/path/to/file")
     defer file.Close()
     part1,
         errFile1 := writer.CreateFormFile("inputFile1",filepath.Base("/path/to/file"))
     _, errFile1 = io.Copy(part1, file)
     if errFile1 != nil {
          fmt.Println(errFile1)
          return
     }
     file, errFile2 := os.Open("/path/to/file")
     defer file.Close()
     part2,
         errFile2 := writer.CreateFormFile("inputFile2",filepath.Base("/path/to/file"))
     _, errFile2 = io.Copy(part2, file)
     if errFile2 != nil {
          fmt.Println(errFile2)
          return
     }
     file, errFile3 := os.Open("/path/to/file")
     defer file.Close()
     part3,
         errFile3 := writer.CreateFormFile("inputFile3",filepath.Base("/path/to/file"))
     _, errFile3 = io.Copy(part3, file)
     if errFile3 != nil {
          fmt.Println(errFile3)
          return
     }
     file, errFile4 := os.Open("/path/to/file")
     defer file.Close()
     part4,
         errFile4 := writer.CreateFormFile("inputFile4",filepath.Base("/path/to/file"))
     _, errFile4 = io.Copy(part4, file)
     if errFile4 != nil {
          fmt.Println(errFile4)
          return
     }
     file, errFile5 := os.Open("/path/to/file")
     defer file.Close()
     part5,
         errFile5 := writer.CreateFormFile("inputFile5",filepath.Base("/path/to/file"))
     _, errFile5 = io.Copy(part5, file)
     if errFile5 != nil {
          fmt.Println(errFile5)
          return
     }
     file, errFile6 := os.Open("/path/to/file")
     defer file.Close()
     part6,
         errFile6 := writer.CreateFormFile("inputFile6",filepath.Base("/path/to/file"))
     _, errFile6 = io.Copy(part6, file)
     if errFile6 != nil {
          fmt.Println(errFile6)
          return
     }
     file, errFile7 := os.Open("/path/to/file")
     defer file.Close()
     part7,
         errFile7 := writer.CreateFormFile("inputFile7",filepath.Base("/path/to/file"))
     _, errFile7 = io.Copy(part7, file)
     if errFile7 != nil {
          fmt.Println(errFile7)
          return
     }
     file, errFile8 := os.Open("/path/to/file")
     defer file.Close()
     part8,
         errFile8 := writer.CreateFormFile("inputFile8",filepath.Base("/path/to/file"))
     _, errFile8 = io.Copy(part8, file)
     if errFile8 != nil {
          fmt.Println(errFile8)
          return
     }
     file, errFile9 := os.Open("/path/to/file")
     defer file.Close()
     part9,
         errFile9 := writer.CreateFormFile("inputFile9",filepath.Base("/path/to/file"))
     _, errFile9 = io.Copy(part9, file)
     if errFile9 != nil {
          fmt.Println(errFile9)
          return
     }
     file, errFile10 := os.Open("/path/to/file")
     defer file.Close()
     part10,
         errFile10 := writer.CreateFormFile("inputFile10",filepath.Base("/path/to/file"))
     _, errFile10 = io.Copy(part10, file)
     if errFile10 != nil {
          fmt.Println(errFile10)
          return
     }
     err := writer.Close()
     if err != nil {
          fmt.Println(err)
          return
     }
client := &http.Client {
     }
     req, err := http.NewRequest(method, url, payload)
if err != nil {
          fmt.Println(err)
          return
     }
     req.Header.Add("Content-Type", "multipart/form-data")
     req.Header.Add("Apikey", "YOUR-API-KEY-HERE")
req.Header.Set("Content-Type", writer.FormDataContentType())
     res, err := client.Do(req)
     if err != nil {
          fmt.Println(err)
          return
     }
     defer res.Body.Close()
body, err := ioutil.ReadAll(res.Body)
     if err != nil {
          fmt.Println(err)
          return
     }
     fmt.Println(string(body))
}
~~~

输出将在一个整齐的文件中捕获所有原始文档。前往[Cloudmersive](https://cloudmersive.com/)网站检索您的免费API密钥，并获得整个API库中每月800次调用的权限。