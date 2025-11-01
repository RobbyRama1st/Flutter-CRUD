# Flutter BLoC CRUD Application

Sebuah aplikasi mobile yang dibangun dengan Flutter untuk mendemonstrasikan alur kerja otentikasi dan CRUD (Create, Read, Update, Delete). Proyek ini menggunakan BLoC untuk _state management_ dan berinteraksi dengan API publik `dummyjson.com`.

Aplikasi ini dirancang dengan UI yang modern, bersih, dan konsisten, menampilkan efek _glassmorphism_ dan komponen kustom yang serasi di semua layar.

## 📱 Coba Aplikasinya (Unduh APK)

Unduh dan instal APK untuk pengujian langsung pada perangkat Android melalui tautan di bawah ini:

**➡️ [Unduh APK via Diawi](https://i.diawi.com/M1ha3m)**

## ✨ Fitur Utama

- **Otentikasi Pengguna:** Halaman login yang terhubung ke endpoint `/auth/login`.
- **Manajemen Token:** Menyimpan dan mengambil token otentikasi JWT dengan aman menggunakan `shared_preferences`.
- **Operasi CRUD Penuh:**
  - **Create:** Menambahkan post baru ke server.
  - **Read:** Mengambil dan menampilkan daftar post.
  - **Update:** Mengedit post yang sudah ada.
  - **Delete:** Menghapus post dari server.
- **State Management:** Arsitektur yang bersih dan terukur menggunakan `flutter_bloc` dan `BlocObserver`.
- **UI Modern:** Desain yang konsisten dan modern di semua layar, termasuk:
  - Efek _Glassmorphism_ (Frosted Glass)
  - _Widget_ formulir dan _card list_ kustom dengan _rounded corner_ dan _shadow_ yang lembut.
  - _Header_ kustom dan _loading indicator_ yang terintegrasi.
- **Networking:** Penanganan permintaan HTTP yang efisien menggunakan `dio`.
- **Debugging:** _Logging_ yang terperinci untuk _request/response_ API (melalui `LogInterceptor`) dan transisi _state_ (melalui `BlocObserver`).
- **Umpan Balik Pengguna:** Indikator _loading_ dan pesan _error/success_ yang jelas menggunakan `SnackBar`.
- **Pull-to-Refresh:** Memuat ulang daftar post dengan gestur tarik ke bawah.

---

## 🏗️ Arsitektur & Tech Stack

Proyek ini dibangun dengan mengikuti prinsip _clean architecture_ untuk memisahkan logika, data, dan UI.

- **Framework:** **Flutter**
- **State Management:** **`flutter_bloc`** / **`equatable`**
- **Networking:** **`dio`**
- **Penyimpanan Lokal:** **`shared_preferences`**
- **Logging:** **`logger`**

Struktur proyek dibagi menjadi tiga lapisan utama:

1.  **Data Layer**

    - **Services (`ApiService`):** Bertanggung jawab atas panggilan HTTP menggunakan `dio` dan `LogInterceptor`.
    - **Repositories (`AuthRepository`, `PostRepository`):** Mengabstraksi sumber data dan menyediakan API yang untuk BLoC. Mengelola penyimpanan token.

2.  **Logic Layer (BLoC)**

    - **`AuthBloc`:** Mengelola _state_ untuk proses _login_ dan _logout_.
    - **`PostBloc`:** Mengelola semua _state_ yang terkait dengan operasi CRUD pada post (`PostsFetched`, `PostAdded`, `PostUpdated`, `PostDeleted`).

3.  **UI Layer (Pages & Widgets)**
    - Menampilkan _state_ dari BLoC dan mengirimkan _event_ berdasarkan interaksi pengguna.
    - Dibangun dengan fokus pada _widget_ yang dapat digunakan kembali dan desain yang konsisten.

---

## 🚀 Memulai

### Prasyarat

- SDK Flutter (versi 3.x.x atau lebih baru)
- Editor Kode (VS Code, Android Studio, dll.)
- Emulator Android atau Perangkat Fisik

### Instalasi

1.  **Clone repositori:**

    ```bash
    git clone "https://github.com/RobbyRama1st/Flutter-CRUD/"
    cd [nama_proyek]
    ```

2.  **Instal dependensi:**

    ```bash
    flutter pub get
    ```

3.  **Jalankan aplikasi:**
    ```bash
    flutter run
    ```

---

## ⚠️ Catatan Penting: Perilaku API `dummyjson.com`

Proyek ini menggunakan API `dummyjson.com`, yang merupakan API "dummny/palsu" untuk pengujian dan pembuatan prototipe.

> **PENTING:** Server `dummyjson.com` **tidak menyimpan perubahan data** yang dikirim melalui `POST` (Tambah), `PUT` (Update), atau `DELETE` (Hapus).

### Apa yang terjadi di Aplikasi

Aplikasi ini dirancang untuk menangani skenario nyata. Alurnya adalah sebagai berikut:

1.  Saat pengguna menekan tombol "Hapus" pada sebuah post.
2.  `PostBloc` mengirimkan _event_ `PostDeleted`.
3.  Aplikasi menampilkan _loading indicator_ (`PostOperationInProgress`).
4.  `ApiService` mengirimkan permintaan `DELETE` ke `dummyjson.com`.
5.  Server `dummyjson.com` merespons dengan **status sukses `200 OK`**, seolah-olah post tersebut benar-benar dihapus.
6.  `PostBloc` menerima respons sukses ini dan mengeluarkan _state_ `PostOperationSuccess`.
7.  `BlocListener` di UI mendeteksi _state_ sukses ini, menampilkan `SnackBar` "Post berhasil dihapus", dan kemudian memanggil _event_ `PostsFetched()` untuk me-refresh daftar.
8.  Saat `GET /posts` dipanggil, server `dummyjson.com` mengembalikan **daftar post asli yang tidak berubah**, karena penghapusan tidak pernah disimpan didatabase dummyjson.
9.  UI me-render ulang, dan post yang "dihapus" tadi muncul kembali.

Perilaku ini **diharapkan** dan **membuktikan bahwa alur _state_ aplikasi (Loading -> Sukses -> Refresh) berfungsi dengan benar.** Hal yang sama berlaku untuk `POST` (Add) dan `PUT` (Update).

