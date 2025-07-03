
%% 
function SoilTextureAnalyzer
    % Aplikasi GUI Modern untuk Analisis Tekstur Tanah menggunakan GLCM - IMPROVED & FIXED
    % Author: Enhanced Version with Better Classification Algorithm
    
    % Inisialisasi variabel dengan struktur data
    appData = struct();
    appData.img = [];
    appData.grayImg = [];
    appData.contrast = 0;
    appData.energy = 0;
    appData.homogeneity = 0;
    appData.correlation = 0;
    appData.entropy = 0;
    appData.classification = '';
    
    % Membuat figure utama
    fig = uifigure('Name', 'Soil Texture Analyzer v2.1 - Improved & Fixed', ...
                   'Position', [100, 100, 1200, 800], ...
                   'Color', [0.95, 0.95, 0.97], ...
                   'Resize', 'off');
    
    % Header Panel
    headerPanel = uipanel(fig, 'Position', [20, 720, 1160, 60], ...
                         'BackgroundColor', [0.2, 0.4, 0.6], ...
                         'BorderType', 'none');
    
    uiLabel = uilabel(headerPanel, 'Text', 'SOIL TEXTURE ANALYZER - IMPROVED & FIXED', ...
                     'Position', [20, 15, 600, 30], ...
                     'FontSize', 24, 'FontWeight', 'bold', ...
                     'FontColor', 'white');
    
    subLabel = uilabel(headerPanel, 'Text', 'Analisis Tekstur Tanah dengan Algoritma Klasifikasi yang Ditingkatkan', ...
                      'Position', [20, 0, 800, 20], ...
                      'FontSize', 12, 'FontColor', [0.8, 0.9, 1]);
    
    % Control Panel (Kiri)
    controlPanel = uipanel(fig, 'Position', [20, 20, 280, 680], ...
                          'Title', 'KONTROL PANEL', ...
                          'FontSize', 12, 'FontWeight', 'bold', ...
                          'BackgroundColor', 'white', ...
                          'BorderWidth', 2);
    
    % Tombol Upload dengan ikon
    uploadBtn = uibutton(controlPanel, 'push', ...
                        'Text', '📁 UPLOAD GAMBAR', ...
                        'Position', [20, 600, 240, 40], ...
                        'FontSize', 12, 'FontWeight', 'bold', ...
                        'BackgroundColor', [0.2, 0.7, 0.3], ...
                        'FontColor', 'white', ...
                        'ButtonPushedFcn', @uploadImage);
    
    % Tombol Analisis
    analyzeBtn = uibutton(controlPanel, 'push', ...
                         'Text', '🔬 ANALISIS TEKSTUR', ...
                         'Position', [20, 550, 240, 40], ...
                         'FontSize', 12, 'FontWeight', 'bold', ...
                         'BackgroundColor', [0.8, 0.4, 0.1], ...
                         'FontColor', 'white', ...
                         'Enable', 'off', ...
                         'ButtonPushedFcn', @analyzeTexture);
    
    % Tombol Reset
    resetBtn = uibutton(controlPanel, 'push', ...
                       'Text', '🔄 RESET', ...
                       'Position', [20, 500, 240, 40], ...
                       'FontSize', 12, 'FontWeight', 'bold', ...
                       'BackgroundColor', [0.7, 0.2, 0.2], ...
                       'FontColor', 'white', ...
                       'ButtonPushedFcn', @resetAll);
    
    % Panel Informasi File
    infoPanel = uipanel(controlPanel, 'Position', [10, 420, 260, 60], ...
                       'Title', 'Informasi File', ...
                       'BackgroundColor', [0.95, 0.95, 0.95]);
    
    fileNameLabel = uilabel(infoPanel, 'Text', 'Belum ada file dipilih', ...
                           'Position', [10, 25, 240, 15], ...
                           'FontSize', 9, 'FontColor', [0.5, 0.5, 0.5]);
    
    fileSizeLabel = uilabel(infoPanel, 'Text', '', ...
                           'Position', [10, 10, 240, 15], ...
                           'FontSize', 9, 'FontColor', [0.5, 0.5, 0.5]);
    
    % Panel Hasil GLCM - DIPERLUAS
    glcmPanel = uipanel(controlPanel, 'Position', [10, 180, 260, 230], ...
                       'Title', 'Hasil Analisis GLCM', ...
                       'BackgroundColor', [0.95, 0.95, 0.95]);
    
    % Label untuk nilai GLCM - DITAMBAHKAN
    contrastLabel = uilabel(glcmPanel, 'Text', 'Contrast: -', ...
                           'Position', [10, 190, 240, 15], ...
                           'FontSize', 10, 'FontWeight', 'bold');
    
    energyLabel = uilabel(glcmPanel, 'Text', 'Energy: -', ...
                         'Position', [10, 170, 240, 15], ...
                         'FontSize', 10, 'FontWeight', 'bold');
    
    homogeneityLabel = uilabel(glcmPanel, 'Text', 'Homogeneity: -', ...
                              'Position', [10, 150, 240, 15], ...
                              'FontSize', 10, 'FontWeight', 'bold');
    
    correlationLabel = uilabel(glcmPanel, 'Text', 'Correlation: -', ...
                              'Position', [10, 130, 240, 15], ...
                              'FontSize', 10, 'FontWeight', 'bold');
    
    entropyLabel = uilabel(glcmPanel, 'Text', 'Entropy: -', ...
                          'Position', [10, 110, 240, 15], ...
                          'FontSize', 10, 'FontWeight', 'bold');
    
    % Panel Klasifikasi
    classPanel = uipanel(glcmPanel, 'Position', [10, 10, 240, 90], ...
                        'BackgroundColor', [0.9, 0.9, 0.9]);
    
    classLabel = uilabel(classPanel, 'Text', 'HASIL KLASIFIKASI', ...
                        'Position', [10, 65, 220, 15], ...
                        'FontSize', 10, 'FontWeight', 'bold', ...
                        'HorizontalAlignment', 'center');
    
    resultLabel = uilabel(classPanel, 'Text', 'Belum dianalisis', ...
                         'Position', [10, 35, 220, 25], ...
                         'FontSize', 12, 'FontWeight', 'bold', ...
                         'HorizontalAlignment', 'center', ...
                         'FontColor', [0.5, 0.5, 0.5]);
    
    confidenceLabel = uilabel(classPanel, 'Text', '', ...
                             'Position', [10, 15, 220, 15], ...
                             'FontSize', 9, 'HorizontalAlignment', 'center');
    
    % Panel Progress
    progressPanel = uipanel(controlPanel, 'Position', [10, 120, 260, 50], ...
                           'Title', 'Status Proses', ...
                           'BackgroundColor', [0.95, 0.95, 0.95]);
    
    statusLabel = uilabel(progressPanel, 'Text', 'Siap untuk memulai analisis', ...
                         'Position', [10, 15, 240, 20], ...
                         'FontSize', 10, 'FontColor', [0.3, 0.6, 0.3]);
    
    % Panel Bantuan
    helpPanel = uipanel(controlPanel, 'Position', [10, 10, 260, 100], ...
                       'Title', 'Panduan Penggunaan', ...
                       'BackgroundColor', [0.95, 0.95, 1]);
    
    helpText = uilabel(helpPanel, 'Text', ...
                      {'1. Upload gambar tanah (JPG, PNG, dll)', ...
                       '2. Klik Analisis untuk memproses GLCM', ...
                       '3. Lihat hasil klasifikasi & interpretasi', ...
                       '4. Gunakan Reset untuk analisis baru'}, ...
                      'Position', [10, 10, 240, 70], ...
                      'FontSize', 9, 'FontColor', [0.3, 0.3, 0.7]);
    
    % Panel Gambar Asli
    originalPanel = uipanel(fig, 'Position', [320, 380, 420, 320], ...
                           'Title', 'CITRA ASLI', ...
                           'BackgroundColor', 'white', ...
                           'FontSize', 12, 'FontWeight', 'bold');
    
    originalAxes = uiaxes(originalPanel, 'Position', [10, 10, 400, 280]);
    originalAxes.XTick = [];
    originalAxes.YTick = [];
    originalAxes.Box = 'on';
    
    % Panel Gambar Grayscale
    grayPanel = uipanel(fig, 'Position', [760, 380, 420, 320], ...
                       'Title', 'CITRA GRAYSCALE & PREPROCESSING', ...
                       'BackgroundColor', 'white', ...
                       'FontSize', 12, 'FontWeight', 'bold');
    
    grayAxes = uiaxes(grayPanel, 'Position', [10, 10, 400, 280]);
    grayAxes.XTick = [];
    grayAxes.YTick = [];
    grayAxes.Box = 'on';
    
    % Panel Grafik Histogram
    histPanel = uipanel(fig, 'Position', [320, 20, 420, 340], ...
                       'Title', 'HISTOGRAM & DISTRIBUSI', ...
                       'BackgroundColor', 'white', ...
                       'FontSize', 12, 'FontWeight', 'bold');
    
    histAxes = uiaxes(histPanel, 'Position', [20, 20, 380, 280]);
    
    % Panel Statistik Detail
    statsPanel = uipanel(fig, 'Position', [760, 20, 420, 340], ...
                        'Title', 'ANALISIS & INTERPRETASI', ...
                        'BackgroundColor', 'white', ...
                        'FontSize', 12, 'FontWeight', 'bold');
    
    % Tabel untuk menampilkan statistik
    statsTable = uitable(statsPanel, 'Position', [20, 180, 380, 140], ...
                        'ColumnName', {'Parameter', 'Nilai', 'Interpretasi'}, ...
                        'ColumnWidth', {120, 80, 175}, ...
                        'Data', {'Contrast', '-', '-'; 'Energy', '-', '-'; 'Homogeneity', '-', '-'; ...
                                'Correlation', '-', '-'; 'Entropy', '-', '-'; 'Std Dev', '-', '-'});
    
    % Panel interpretasi
    interpretPanel = uipanel(statsPanel, 'Position', [20, 20, 380, 150], ...
                            'BackgroundColor', [0.95, 0.95, 1]);
    
    interpretLabel = uilabel(interpretPanel, 'Text', 'INTERPRETASI HASIL:', ...
                            'Position', [10, 120, 360, 20], ...
                            'FontSize', 11, 'FontWeight', 'bold');
    
    interpretText = uilabel(interpretPanel, 'Text', ...
                           'Silakan lakukan analisis terlebih dahulu untuk melihat interpretasi hasil.', ...
                           'Position', [10, 10, 360, 100], ...
                           'FontSize', 10, ...
                           'WordWrap', 'on');
    
    % ================ FUNGSI PREPROCESSING YANG DITINGKATKAN ================
    function processedImg = preprocessImage(img)
        % Preprocessing untuk meningkatkan akurasi analisis tekstur
        
        % 1. Resize jika terlalu besar (untuk konsistensi)
        [h, w] = size(img);
        if max(h, w) > 512
            scale = 512 / max(h, w);
            img = imresize(img, scale);
        end
        
        % 2. Noise reduction dengan median filter
        img = medfilt2(img, [5 5]); 
        
        % 3. Contrast enhancement dengan CLAHE - Disesuaikan lebih lanjut untuk tanah halus
        img = adapthisteq(img, 'NumTiles', [32 32], 'ClipLimit', 0.008); 
        
        % 4. Normalisasi intensitas
        img = im2uint8(mat2gray(img));
        
        processedImg = img;
    end
    
    % ================ FUNGSI KLASIFIKASI YANG DITINGKATKAN ================
    function [classification, confidence, interpretation] = classifyTexture(contrast, energy, homogeneity, correlation, entropyVal, stdDev)
        % Algoritma klasifikasi yang lebih sophisticated dengan multiple features
        
        % Normalisasi fitur untuk scoring
        contrastNorm = min(contrast / 2.0, 1.0);  % Normalized contrast
        energyNorm = min(energy * 5, 1.0);        % Normalized energy  
        homogeneityNorm = homogeneity;            % Already 0-1
        correlationNorm = (correlation + 1) / 2;  % Convert -1,1 to 0,1
        entropyNorm = min(entropyVal / 8, 1.0);   % Normalized entropy
        stdNorm = min(stdDev / 100, 1.0);         % Normalized std dev
        
        % ============ MULTI-CRITERIA SCORING ============
        
        % Score untuk TEKSTUR KASAR (semakin tinggi = semakin kasar)
        coarseScore = 0;
        coarseScore = coarseScore + (contrastNorm * 0.2);        
        coarseScore = coarseScore + ((1-energyNorm) * 0.25);     
        coarseScore = coarseScore + ((1-homogeneityNorm) * 0.2); 
        coarseScore = coarseScore + (entropyNorm * 0.08);        
        coarseScore = coarseScore + (stdNorm * 0.27);            
        
        % Score untuk TEKSTUR HALUS (semakin tinggi = semakin halus)
        fineScore = 0;
        fineScore = fineScore + ((1-contrastNorm) * 0.4);      
        fineScore = fineScore + (energyNorm * 0.25);           
        fineScore = fineScore + (homogeneityNorm * 0.2);       
        fineScore = fineScore + ((1-entropyNorm) * 0.22);      
        fineScore = fineScore + ((1-stdNorm) * 0.1);           
        
        % ============ ADVANCED DECISION LOGIC ============
        
        % Inisialisasi interpretation di awal fungsi untuk memastikan selalu terisi
        classification = ''; % Pastikan ini juga diinisialisasi
        confidence = 0;      % Pastikan ini juga diinisialisasi
        interpretation = 'Interpretasi tidak tersedia untuk kasus ini.'; % Default interpretation
        
        % Hitung confidence sebagai selisih score
        scoreDiff = abs(coarseScore - fineScore);
        confidence = min(scoreDiff * 100, 95); % Max 95% confidence
        
        % Decision dengan threshold yang lebih sensitif
        threshold = 0.05; 
        
        if coarseScore > (fineScore + threshold)
            classification = 'TEKSTUR KASAR';
            % dominant_score tidak perlu dideklarasikan sebagai output, hanya untuk lokal
            % dominant_score = coarseScore; 
            interpretation = sprintf(['TEKSTUR KASAR TERDETEKSI (Confidence: %.1f%%)\n\n' ...
                'Indikator Tekstur Kasar:\n' ...
                '• Contrast: %.3f %s\n' ...
                '• Energy: %.3f %s\n' ...
                '• Homogeneity: %.3f %s\n' ...
                '• Entropy: %.3f %s\n' ...
                '• Std Deviation: %.2f %s\n\n' ...
                'Karakteristik: Tanah dengan butiran besar, struktur heterogen, ' ...
                'kemungkinan berpasir, berkerikil, atau bertekstur granular. ' ...
                'Variasi intensitas tinggi menunjukkan ketidakseragaman partikel.'], ...
                confidence, ...
                contrast, getIndicator(contrast, 'contrast', 'coarse'), ...
                energy, getIndicator(energy, 'energy', 'coarse'), ...
                homogeneity, getIndicator(homogeneity, 'homogeneity', 'coarse'), ...
                entropyVal, getIndicator(entropyVal, 'entropy', 'coarse'), ...
                stdDev, getIndicator(stdDev, 'std', 'coarse'));
        elseif fineScore > (coarseScore + threshold)
            classification = 'TEKSTUR HALUS';
            % dominant_score tidak perlu dideklarasikan sebagai output, hanya untuk lokal
            % dominant_score = fineScore;
            interpretation = sprintf(['TEKSTUR HALUS TERDETEKSI (Confidence: %.1f%%)\n\n' ...
                'Indikator Tekstur Halus:\n' ...
                '• Contrast: %.3f %s\n' ...
                '• Energy: %.3f %s\n' ...
                '• Homogeneity: %.3f %s\n' ...
                '• Entropy: %.3f %s\n\n' ...
                '• Std Deviation: %.2f %s\n\n' ...
                'Karakteristik: Tanah dengan butiran kecil, struktur homogen, ' ...
                'kemungkinan berlempung, berlanau, atau bertekstur uniform. ' ...
                'Variasi intensitas rendah menunjukkan keseragaman partikel.'], ...
                confidence, ...
                contrast, getIndicator(contrast, 'contrast', 'fine'), ...
                energy, getIndicator(energy, 'energy', 'fine'), ...
                homogeneity, getIndicator(homogeneity, 'homogeneity', 'fine'), ...
                entropyVal, getIndicator(entropyVal, 'entropy', 'fine'), ...
                stdDev, getIndicator(stdDev, 'std', 'fine'));
        else
            % Ambiguous case - Kriteria sekunder lebih condong ke halus jika ragu
            if contrast > 1.0 || entropyVal > 5 
                classification = 'TEKSTUR KASAR';
                % dominant_score tidak perlu dideklarasikan sebagai output, hanya untuk lokal
                % dominant_score = coarseScore;
                interpretation = sprintf(['TEKSTUR KASAR TERDETEKSI (Confidence Rendah: %.1f%%)\n\n' ...
                    'Indikator Campuran: Nilai fitur mendekati batas antara kasar dan halus. ' ...
                    'Namun, beberapa indikator (Kontras: %.3f, Entropi: %.3f) menunjukkan kecenderungan kasar. ' ...
                    'Periksa kembali kondisi gambar atau parameter input.'], ...
                    confidence, contrast, entropyVal);
            else 
                classification = 'TEKSTUR HALUS';
                % dominant_score tidak perlu dideklarasikan sebagai output, hanya untuk lokal
                % dominant_score = fineScore;
                 interpretation = sprintf(['TEKSTUR HALUS TERDETEKSI (Confidence Rendah: %.1f%%)\n\n' ...
                    'Indikator Campuran: Nilai fitur mendekati batas antara kasar dan halus. ' ...
                    'Namun, tidak ada indikator kuat untuk tekstur kasar (Kontras: %.3f, Entropi: %.3f), sehingga lebih condong ke halus. ' ...
                    'Periksa kembali kondisi gambar atau parameter input.'], ...
                    confidence, contrast, entropyVal);
            end
            confidence = confidence * 0.7; 
        end
        
        fprintf('DEBUG: Coarse Score = %.3f, Fine Score = %.3f, Confidence = %.1f%%\n', ...
                coarseScore, fineScore, confidence);
    end
    
    % ================ FUNGSI HELPER: INTERPRETASI INDIKATOR ================
    % Definisi fungsi getIndicator yang BENAR dan hanya ada SATU di sini
    function indicator = getIndicator(value, param, textureType)
        switch param
            case 'contrast'
                if strcmp(textureType, 'coarse')
                    indicator = sprintf('(Tinggi - mendukung kasar)');
                else
                    indicator = sprintf('(Rendah - mendukung halus)');
                end
            case 'energy'
                if strcmp(textureType, 'coarse')
                    indicator = sprintf('(Rendah - mendukung kasar)');
                else
                    indicator = sprintf('(Tinggi - mendukung halus)');
                end
            case 'homogeneity'
                if strcmp(textureType, 'coarse')
                    indicator = sprintf('(Rendah - mendukung kasar)');
                else
                    indicator = sprintf('(Tinggi - mendukung halus)');
                end
            case 'correlation'
                if strcmp(textureType, 'coarse')
                    indicator = sprintf('(Tinggi - mendukung kasar)');
                else
                    indicator = sprintf('(Rendah - mendukung halus)');
                end
            case 'entropy'
                if strcmp(textureType, 'coarse')
                    indicator = sprintf('(Tinggi - mendukung kasar)');
                else
                    indicator = sprintf('(Rendah - mendukung halus)');
                end
            case 'std'
                if strcmp(textureType, 'coarse')
                    indicator = sprintf('(Tinggi - mendukung kasar)');
                else
                    indicator = sprintf('(Rendah - mendukung halus)');
                end
        end
    end
    
    % ================ FUNGSI UPLOAD GAMBAR ================
    function uploadImage(~, ~)
        [file, path] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp;*.tiff', ...
                                 'Image Files (*.jpg,*.jpeg,*.png,*.bmp,*.tiff)'}, ...
                                'Pilih Gambar Tanah untuk Dianalisis');
        
        if isequal(file, 0)
            statusLabel.Text = 'Upload dibatalkan';
            statusLabel.FontColor = [0.8, 0.3, 0.3];
            return;
        end
        
        try
            statusLabel.Text = 'Memproses gambar...';
            statusLabel.FontColor = [0.8, 0.6, 0.1];
            drawnow;
            
            % Baca gambar
            appData.img = imread(fullfile(path, file));
            
            % Update informasi file
            fileInfo = dir(fullfile(path, file));
            fileNameLabel.Text = ['File: ' file];
            fileSizeLabel.Text = ['Size: ' num2str(round(fileInfo.bytes/1024)) ' KB'];
            
            % Tampilkan gambar asli
            imshow(appData.img, 'Parent', originalAxes);
            title(originalAxes, 'Gambar Tanah Original', 'FontSize', 10);
            
            % Konversi ke grayscale dan preprocessing
            if size(appData.img, 3) == 3
                grayTemp = rgb2gray(appData.img);
            else
                grayTemp = appData.img;
            end
            
            % PREPROCESSING YANG DITINGKATKAN
            appData.grayImg = preprocessImage(grayTemp);
            
            % Tampilkan gambar grayscale yang sudah diproses
            imshow(appData.grayImg, 'Parent', grayAxes);
            title(grayAxes, 'Grayscale + Preprocessing', 'FontSize', 10);
            
            % Tampilkan histogram dengan histogram() function
            histogram(histAxes, appData.grayImg(:), 64, 'FaceColor', [0.3, 0.6, 0.8]);
            title(histAxes, 'Histogram Intensitas (Setelah Preprocessing)', 'FontSize', 10);
            xlabel(histAxes, 'Intensitas Pixel');
            ylabel(histAxes, 'Frekuensi');
            grid(histAxes, 'on');
            
            % Tambahkan info statistik dasar di histogram
            meanVal = mean(appData.grayImg(:));
            stdVal = std(double(appData.grayImg(:)));
            hold(histAxes, 'on');
            line(histAxes, [meanVal meanVal], ylim(histAxes), 'Color', 'red', 'LineWidth', 2);
            legend(histAxes, {'Histogram', sprintf('Mean = %.1f', meanVal)}, 'Location', 'best');
            hold(histAxes, 'off');
            
            % AKTIFKAN tombol analisis
            analyzeBtn.Enable = 'on';
            analyzeBtn.BackgroundColor = [0.8, 0.4, 0.1];
            
            statusLabel.Text = 'Gambar berhasil dimuat dan diproses!';
            statusLabel.FontColor = [0.3, 0.6, 0.3];
            
            fprintf('DEBUG: Image loaded and preprocessed. Size: %dx%d\n', size(appData.grayImg,1), size(appData.grayImg,2));
            
        catch ME
            statusLabel.Text = ['Error: ' ME.message];
            statusLabel.FontColor = [0.8, 0.3, 0.3];
            analyzeBtn.Enable = 'off';
            fprintf('ERROR: %s\n', ME.message);
        end
    end
    
    % ================ FUNGSI ANALISIS TEKSTUR YANG DITINGKATKAN ================
    function analyzeTexture(~, ~)
        if isempty(appData.grayImg)
            statusLabel.Text = 'ERROR: Tidak ada gambar untuk dianalisis!';
            statusLabel.FontColor = [0.8, 0.3, 0.3];
            return;
        end
        
        try
            statusLabel.Text = 'Menganalisis tekstur dengan algoritma canggih...';
            statusLabel.FontColor = [0.8, 0.6, 0.1];
            
            % Disable tombol sementara
            analyzeBtn.Enable = 'off';
            analyzeBtn.BackgroundColor = [0.6, 0.6, 0.6];
            drawnow;
            
            % ============ PERHITUNGAN GLCM YANG DITINGKATKAN DAN DIPERBAIKI ============
            fprintf('DEBUG: Computing enhanced GLCM...\n');
            
            % Fixed: Gunakan offset yang sudah didefinisikan dengan baik (integer values)
            % Definisi offset yang benar untuk 4 arah dengan jarak 1 dan 2
            offsets = int8([0 1; -1 1; -1 0; -1 -1; 0 2; -2 2; -2 0; -2 -2]); 
            
            % Kurangi jumlah gray levels untuk mengurangi noise
            numLevels = 16; % Optimized number of levels
            
            % Fixed: Compute GLCM dengan parameter yang sudah diperbaiki
            glcm = graycomatrix(appData.grayImg, 'Offset', offsets, ...
                               'Symmetric', true, 'NumLevels', numLevels);
            
            % Ekstrak fitur tekstur
            stats = graycoprops(glcm, {'contrast', 'energy', 'homogeneity', 'correlation'});
            
            % Hitung rata-rata dari semua arah dan jarak
            appData.contrast = mean(stats.Contrast);
            appData.energy = mean(stats.Energy);
            appData.homogeneity = mean(stats.Homogeneity);
            appData.correlation = mean(stats.Correlation);
            
            % Hitung statistik tambahan
            meanIntensity = mean(appData.grayImg(:));
            stdIntensity = std(double(appData.grayImg(:)));
            appData.entropy = entropy(appData.grayImg);
            
            fprintf('DEBUG: Features - Contrast:%.4f, Energy:%.4f, Homogeneity:%.4f, Entropy:%.4f\n', ...
                    appData.contrast, appData.energy, appData.homogeneity, appData.entropy);
            
            % ============ KLASIFIKASI DENGAN ALGORITMA YANG DITINGKATKAN ============
            [classification, confidence, interpretation] = classifyTexture(...
                appData.contrast, appData.energy, appData.homogeneity, ...
                appData.correlation, appData.entropy, stdIntensity);
            
            appData.classification = classification;
            
            % ============ UPDATE UI DENGAN HASIL ============
            
            % Update label GLCM dengan lebih banyak informasi
            contrastLabel.Text = sprintf('Contrast: %.4f', appData.contrast);
            energyLabel.Text = sprintf('Energy: %.4f', appData.energy);
            homogeneityLabel.Text = sprintf('Homogeneity: %.4f', appData.homogeneity);
            correlationLabel.Text = sprintf('Correlation: %.4f', appData.correlation);
            entropyLabel.Text = sprintf('Entropy: %.4f', appData.entropy);
            
            % Update tabel statistik dengan interpretasi
            statsTable.Data = {
                'Contrast', sprintf('%.4f', appData.contrast), getFeatureInterpretation(appData.contrast, 'contrast');
                'Energy', sprintf('%.4f', appData.energy), getFeatureInterpretation(appData.energy, 'energy');
                'Homogeneity', sprintf('%.4f', appData.homogeneity), getFeatureInterpretation(appData.homogeneity, 'homogeneity');
                'Correlation', sprintf('%.4f', appData.correlation), getFeatureInterpretation(appData.correlation, 'correlation');
                'Entropy', sprintf('%.4f', appData.entropy), getFeatureInterpretation(appData.entropy, 'entropy');
                'Std Dev', sprintf('%.2f', stdIntensity), getFeatureInterpretation(stdIntensity, 'std')
            };
            
            % Update hasil klasifikasi dengan styling yang sesuai
            if contains(classification, 'KASAR')
                resultLabel.Text = '🏔️ TEKSTUR KASAR';
                resultLabel.FontColor = [0.8, 0.3, 0.1];
                classPanel.BackgroundColor = [1, 0.9, 0.8];
            else
                resultLabel.Text = '🌾 TEKSTUR HALUS';
                resultLabel.FontColor = [0.2, 0.6, 0.2];
                classPanel.BackgroundColor = [0.8, 1, 0.8];
            end
          
            
            confidenceLabel.Text = sprintf('Confidence: %.1f%%', confidence);
            confidenceLabel.FontColor = [0.4, 0.4, 0.4];
            
            % Update interpretasi
            interpretText.Text = interpretation;
            
            % Re-enable tombol dengan warna normal
            analyzeBtn.Enable = 'on';
            analyzeBtn.BackgroundColor = [0.8, 0.4, 0.1];
            
            statusLabel.Text = 'Analisis selesai dengan algoritma canggih!';
            statusLabel.FontColor = [0.2, 0.6, 0.2];
            
            fprintf('DEBUG: Analysis completed! Classification: %s (Confidence: %.1f%%)\n', ...
                    classification, confidence);
            
        catch ME
            statusLabel.Text = ['Error dalam analisis: ' ME.message];
            statusLabel.FontColor = [0.8, 0.3, 0.3];
            
            % Re-enable tombol jika error
            analyzeBtn.Enable = 'on';
            analyzeBtn.BackgroundColor = [0.8, 0.4, 0.1];
            
            fprintf('ERROR dalam analisis: %s\n', ME.message);
        end
    end
    
    % ================ FUNGSI HELPER: INTERPRETASI FITUR INDIVIDUAL ================
    % Fungsi getIndicator ini harusnya hanya ada SATU di dalam file.
    % Pastikan tidak ada definisi duplikat di tempat lain.
    function interpretation = getFeatureInterpretation(value, feature)
        switch feature
            case 'contrast'
                if value > 1.0
                    interpretation = 'Tinggi (Kasar)';
                elseif value > 0.5
                    interpretation = 'Sedang';
                else
                    interpretation = 'Rendah (Halus)';
                end
            case 'energy'
                if value > 0.5
                    interpretation = 'Tinggi (Halus)';
                elseif value > 0.2
                    interpretation = 'Sedang';
                else
                    interpretation = 'Rendah (Kasar)';
                end
            case 'homogeneity'
                if value > 0.8
                    interpretation = 'Tinggi (Halus)';
                elseif value > 0.6
                    interpretation = 'Sedang';
                else
                    interpretation = 'Rendah (Kasar)';
                end
            case 'correlation'
                if value > 0.7
                    interpretation = 'Tinggi';
                elseif value > 0.3
                    interpretation = 'Sedang';
                else
                    interpretation = 'Rendah';
                end
            case 'entropy'
                if value > 5
                    interpretation = 'Tinggi (Kasar)';
                elseif value > 3
                    interpretation = 'Sedang';
                else
                    interpretation = 'Rendah (Halus)';
                end
            case 'std'
                if value > 50
                    interpretation = 'Tinggi (Kasar)';
                elseif value > 25
                    interpretation = 'Sedang';
                else
                    interpretation = 'Rendah (Halus)';
                end
        end
    end
    
    % ================ FUNGSI RESET ================
    function resetAll(~, ~)
        % Clear variabel appData
        appData.img = [];
        appData.grayImg = [];
        appData.contrast = 0;
        appData.energy = 0;
        appData.homogeneity = 0;
        appData.correlation = 0;
        appData.entropy = 0;
        appData.classification = '';
        
        % Reset tampilan
        cla(originalAxes);
        cla(grayAxes);
        cla(histAxes);
        
        title(originalAxes, 'Belum ada gambar dimuat', 'FontSize', 10, 'Color', [0.5, 0.5, 0.5]);
        title(grayAxes, 'Preprocessing akan ditampilkan di sini', 'FontSize', 10, 'Color', [0.5, 0.5, 0.5]);
        title(histAxes, 'Histogram akan muncul setelah upload', 'FontSize', 10, 'Color', [0.5, 0.5, 0.5]);
        
        % Reset label
        fileNameLabel.Text = 'Belum ada file dipilih';
        fileSizeLabel.Text = '';
        contrastLabel.Text = 'Contrast: -';
        energyLabel.Text = 'Energy: -';
        homogeneityLabel.Text = 'Homogeneity: -';
        correlationLabel.Text = 'Correlation: -';
        entropyLabel.Text = 'Entropy: -';
        resultLabel.Text = 'Belum dianalisis';
        resultLabel.FontColor = [0.5, 0.5, 0.5];
        confidenceLabel.Text = '';
        classPanel.BackgroundColor = [0.9, 0.9, 0.9];
        
        % Reset tabel
        statsTable.Data = {'Contrast', '-', '-'; 'Energy', '-', '-'; 'Homogeneity', '-', '-'; ...
                          'Correlation', '-', '-'; 'Entropy', '-', '-'; 'Std Dev', '-', '-'};
        
        interpretText.Text = 'Silakan lakukan analisis terlebih dahulu untuk melihat interpretasi hasil.';
        
        % Disable tombol analisis
        analyzeBtn.Enable = 'off';
        analyzeBtn.BackgroundColor = [0.6, 0.6, 0.6];
        
        statusLabel.Text = 'Aplikasi telah direset. Siap untuk analisis baru.';
        statusLabel.FontColor = [0.3, 0.6, 0.3];
        
        fprintf('DEBUG: Reset completed\n');
    end
    
    % ================ INISIALISASI TAMPILAN ================
    % Tampilkan placeholder saat startup
    title(originalAxes, 'Klik "Upload Gambar" untuk memulai', 'FontSize', 12, 'Color', [0.5, 0.5, 0.5]);
    title(grayAxes, 'Preprocessing akan ditampilkan di sini', 'FontSize', 12, 'Color', [0.5, 0.5, 0.5]);
    title(histAxes, 'Histogram akan muncul setelah upload', 'FontSize', 12, 'Color', [0.5, 0.5, 0.5]);
    
    fprintf('=== SOIL TEXTURE ANALYZER v2.1 - IMPROVED ===\n');
    fprintf('Perbaikan yang diterapkan:\n');
    fprintf('1. Preprocessing gambar yang ditingkatkan (lebih halus)\n');
    fprintf('2. Algoritma klasifikasi multi-kriteria (prioritas halus ditingkatkan)\n');
    fprintf('3. Multiple directions dan distances untuk GLCM\n');
    fprintf('4. Sistem scoring yang lebih sensitif\n');
    fprintf('5. Confidence level untuk setiap prediksi\n');
    fprintf('6. Interpretasi yang lebih detail\n');
    fprintf('==================================================\n');
    
end