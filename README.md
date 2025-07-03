# KLASIFIKASI-TEKSTUR-TANAH-BERDASARKAN-EKSTRAKSI-FITUR-GLCM
Proyek ini mengembangkan sistem untuk klasifikasi tekstur tanah (kasar/halus). Dengan memanfaatkan Gray Level Co-occurrence Matrix (GLCM) untuk ekstraksi fitur tekstur dan algoritma klasifikasi multi-kriteria yang ditingkatkan, sistem ini menyediakan analisis otomatis dengan tingkat kepercayaan hasil.
# Fitur Utama
Aplikasi ini menyertakan fitur-fitur penting berikut:
1. Preprocessing Citra Lanjut: Peningkatan citra tanah melalui resizing, noise reduction (filter median), peningkatan kontras adaptif (CLAHE), dan normalisasi intensitas untuk hasil analisis yang optimal.
2. Ekstraksi Fitur GLCM Komprehensif: Perhitungan fitur tekstur tanah (Kontras, Energi, Homogenitas, Korelasi, Entropi) menggunakan GLCM dari berbagai arah dan jarak untuk representasi tekstur yang robust.
3. Algoritma Klasifikasi Multi-Kriteria: Model klasifikasi yang ditingkatkan dan sensitif, dirancang untuk membedakan secara akurat antara tekstur tanah kasar dan halus berdasarkan kombinasi fitur GLCM dan standar deviasi intensitas.
4. Tingkat Kepercayaan (Confidence Level): Memberikan estimasi tingkat kepercayaan untuk setiap hasil klasifikasi, memberikan informasi tambahan tentang keandalan prediksi.
5. Interpretasi Detail: Menampilkan interpretasi mendalam untuk setiap fitur GLCM yang dihitung dan penjelasan rinci mengenai hasil klasifikasi tekstur tanah yang terdeteksi.
# Cara menggunakan
Untuk menjalankan aplikasi ini, Anda memerlukan MATLAB dengan Image Processing Toolbox terinstal.
1. Unduh Repositori: Clone atau unduh repositori ini ke komputer lokal Anda.
2. Buka di MATLAB: Buka file SoilTextureAnalyzer.m di MATLAB.
3. Jalankan Aplikasi: Dari editor MATLAB, klik tombol "Run" atau ketik SoilTextureAnalyzer di Command Window dan tekan Enter.
4. Upload Gambar: Klik tombol "UPLOAD GAMBAR" untuk memilih citra tanah yang ingin dianalisis (mendukung format JPG, PNG, BMP, TIFF).
5. Analisis Tekstur: Setelah gambar dimuat dan diproses awal, klik tombol "ANALISIS TEKSTUR" untuk memulai ekstraksi fitur GLCM dan klasifikasi.
6. Lihat Hasil: Hasil analisis, termasuk nilai-nilai GLCM, klasifikasi tekstur, tingkat kepercayaan, dan interpretasi detail, akan ditampilkan di panel yang sesuai.
7. Reset: Gunakan tombol "RESET" untuk membersihkan tampilan dan memulai analisis baru.

# Penulis: Mohammad Satria Zacky/Github:Rizmyyy
# Dokumentasi Proyek
1. SDeteksi Tanah Halus
![Screenshot 2025-06-24 221748](https://github.com/user-attachments/assets/180cabac-2c30-4cbc-97ba-d1525561a4b7)

![Screenshot 2025-06-25 164806](https://github.com/user-attachments/assets/3dc0c39e-622d-41e5-9fa6-aa7c99e83323)

3. Deteksi Tanah Kasar
![Screenshot 2025-06-24 222458](https://github.com/user-attachments/assets/f51f9bb1-7930-4bc4-8018-807660643805)

![Screenshot 2025-06-25 165633](https://github.com/user-attachments/assets/c730c958-7dbe-4c41-a148-afe81c1ed0cf)

