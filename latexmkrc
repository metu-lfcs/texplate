$pdf_mode = 4;          # LuaLaTeX
$out_dir  = '.build';
$aux_dir  = '.build';
$do_cd    = 1;

$interaction = 'nonstopmode';
$file_line_error = 1;
$synctex = 1;

@default_files = ('main.tex');

my $local_texmf = './tex//';
ensure_path('TEXINPUTS', $local_texmf);
ensure_path('LUAINPUTS', $local_texmf);
