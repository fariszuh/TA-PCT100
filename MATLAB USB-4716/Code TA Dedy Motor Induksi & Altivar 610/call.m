rpm = 750


x = rpm/211.101
[arr_vrpm, arr_time] =ReadWrite(x,0);
arr_vrpm = arr_vrpm';
arr_time = arr_time';


writetable(table([arr_time,arr_vrpm]),"750rpm.txt");
%%writetable(table([arr_time,arr_vrpm]),"coba PI 0.49 0.16 0 1055rpm.txt");