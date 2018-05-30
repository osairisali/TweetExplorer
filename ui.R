require(shiny)

# Define UI ----
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Eksplorasi Twitter Politik di Indonesia"),
  
  navlistPanel(
    
    # Tab Panel 1
    "Mengenai App",
    tabPanel("Mengenai App ini",
             h1("Eksplorasi Sample Tweets"),
             tags$article("App ini adalah prototype sederhana dari analisis sentimen twitter yang bisa dilakukan dengan R. Prototype ini tidak mampu mengambil data stream twitter sebagaimana mestinya karena keterbatasan sumberdaya hosting server. Oleh karena itu, app ini hanya menggunakan sample data tweets pada tanggal 24 dan 25 April 2018 sebagai contoh cara kerja saja.")),
    
    # Tab Panel 2
    "Eksplorasi data sample Tweets",
    tabPanel(
      # subtabpanel 1
      "Eksplorasi Awal Tweet",
      
      ## Penjabaran
      tags$article("Untuk memulai eksplorasi apa saja yang dapat dilakukan, anda perlu untuk megolah data mentah dari twitter. Pengolahan raw data ini dilakukan dengan menyaring twitter dengan bahasa indonesia saja, cleaning tanda-tanda baca elektronik, penggantian kata-kata yang disingkat dengan kata sebenarnya, cleaning stopwords, dan pembuatan keywords terkait dengan politik di Indonesia (seperti jokowi, prabowo, pilpres, pemilu, presiden, pemilihan presiden, bangsa, negara)."),
      br(),
      tags$article("Silakan anda klik tombol berikut untuk memulai pengolahan data awal. Proses mungkin butuh waktu sekitar 3 menit hingga plot grafik muncul."),
      
      ## input & output
      actionButton("sample", "Klik untuk Overview Data Awal"),
      plotOutput("overview")),
    
    # Tab Panel 3
    tabPanel(
      "Timeseries menurut skor keyword",
      
      ## Penjabaran
      tags$article("Data awal tweet yang telah diolah sebelumnya dapat dikategorikan berdasarkan banyaknya kemunculan keyword politik seperti jokowi, prabowo, pilpres, pemilu, presiden, pemilihan presiden, bangsa, negara. Masing-masing tweet dengan keyword tersebut akan menghasilkan skor dengan jumlah kemunculan keyword tersebut."),
      br(),
      tags$article("Anda diharapkan melalui tahapan pertama untuk dapat memproses ke tahapan ini dan begitu seterusnya, dikarenakan aplikasi ini didesain untuk penggunaan secara runtut.
                   Anda dapat menentukan banyaknya tweet dengan skor terntu dengan menggunakan slider yang disediakan"),
      
      ## input & output
      sliderInput("skor",
                  "Pilih skor yang akan ditampilkan",
                  min = 0, max = 8, value = 3),
      numericInput("day",
                   "masukkan 24 atau 25 (tanggal yg tersedia)",
                   value = 24,
                   min = 24,
                   max = 25),
      actionButton("applyskorplot",
                   "Plotting data"),
      plotOutput("skorplot")
      ),
    
    # Tab Panel 4
    tabPanel(
      "Frekuensi ngetweet tertinggi",
      
      ## Penjabaran
      tags$article("Fitur ini menunjukkan ranking jumlah banyaknya tweet yang dikirimkan user selama periode waktu yang disediakan. Tweet ini tentunya yang berkaitan dengan keyword politik seperti yang telah dijelaskan sebelumnya."),
      br(),
      
      ## input & output
      sliderInput("rank",
                  "Pilih banyaknya peringkat yang akan ditampilkan",
                  min = 1,
                  max = 10,
                  value = 2),
      selectInput("daytab4",
                  "Masukkan tanggal yg tersedia",
                  choices = c(24, 25),
                  multiple = T),
      actionButton("applyrank",
                   "Plotting frekuensi user"),
      plotOutput("tweetrank")
      ),
    
    # Tab Panel 5
    tabPanel(
      "User dengan opini politis tertinggi",
      
      ## Penjabaran
      tags$article("Fitur ini menunjukkan ranking user siapa saja yang memiliki tweet politis terbanyak selama rentang waktu tertentu."),
      br(),
      
      ## input & output
      sliderInput("rankuser",
                  "Pilih banyaknya peringkat user yang akan ditampilkan",
                  min = 1,
                  max = 50,
                  value = 2),
      selectInput("daytab5",
                  "Masukkan tanggal yg tersedia",
                  choices = c(24, 25),
                  multiple = T),
      actionButton("applyrankuser",
                   "Plotting rank user"),
      plotOutput("userrank")
      )
    
    )
  
  ))
