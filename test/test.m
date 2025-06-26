function performLinearRegressionFromExcel(filePath)
    try
        T = readtable(filePath);

        numCols = width(T);

        if numCols < 30
            fprintf('오류: Excel 파일에 30개 미만의 열이 있습니다. 현재 열 개수: %d\n', numCols);
            return;
        end

        data30Cols = T(:, 1:30);

        y_table = data30Cols(:, end);
        X_table = data30Cols(:, 1:end-1);

        y_numeric = table2array(y_table);
        X_numeric = table2array(X_table);

        X_col_names = cell(1, size(X_numeric, 2));
        for i = 1:size(X_numeric, 2)
            X_col_names{i} = ['X', num2str(i)];
        end

        dataTableForFit = array2table(X_numeric, 'VariableNames', X_col_names);
        dataTableForFit.Y = y_numeric;

        modelFormula = 'Y ~ ';
        for i = 1:length(X_col_names)
            modelFormula = [modelFormula, X_col_names{i}];
            if i < length(X_col_names)
                modelFormula = [modelFormula, ' + '];
            end
        end

        mdl = fitlm(dataTableForFit, modelFormula);

        fprintf('\n--- 선형 회귀 분석 결과 ---\n');
        disp(mdl);

        fprintf('\n**회귀 계수 (Coefficients):**\n');
        disp(mdl.Coefficients);

        fprintf('\n**결정 계수 (R-squared):** %.4f\n', mdl.Rsquared.Ordinary);

        fprintf('**조정된 결정 계수 (Adjusted R-squared):** %.4f\n', mdl.Rsquared.Adjusted);

        mse = mdl.RMSE^2;
        fprintf('**평균 제곱 오차 (MSE):** %.4f\n', mse);

    catch ME
        fprintf('오류 발생: %s\n', ME.message);
    end
end
