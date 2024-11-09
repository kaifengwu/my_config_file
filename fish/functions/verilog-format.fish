function verilog-format 
  touch tmp;
  verible-verilog-format top.v>>tmp;
  cat tmp>top.v;
  rm tmp;
  echo -e "\n"
end
