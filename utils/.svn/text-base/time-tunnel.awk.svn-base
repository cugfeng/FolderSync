# Get current time
function get_cur_time()
{
	"mktemp" | getline tmpfile
	system("date \"+%F %T\" > " tmpfile)
	getline time < tmpfile
	close(tmpfile)

	return time
}

BEGIN {
	printf("====== [Begin %s] ======\n", get_cur_time())
}

{
	printf("[%s] %s\n", get_cur_time(), $0)
}

END {
	printf("====== [End   %s] ======\n\n\n", get_cur_time())
}

