function [f, key_fr]=f_from_filename(fname)

keys = {'C3','D3','E3','F3','G3','A3','B3','C4','D4','E4','F4','G4','A4','B4','C5','D5','E5','F5','G5','A5','B5'};
%key_fr={28,  30,  32,  33,  35,  37,  39,  40,  42,  44,  45,  47,  49,  51,  52,  54,  56,  57,  59,  61,  63};

keys = cell2mat(keys);     

% Key Index
idx = strfind(keys, fname(1:2));

% Key Frequency
key_fr = (idx+1) + 26 - fix((idx+1)/2/4);

% Key Exception
if key_fr < 28 || key_fr > 63
    key_fr = 28;
end

f = 440*2^((key_fr-49)/12); % Frequency corresponding to the key