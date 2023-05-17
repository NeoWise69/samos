;;;
;;; file_table: simple file table ( '{filename1-sector#, filename2-sector#, ...filenameN-sector#}' )
;;;
db '{calculator-04,program2-06,notepad-09,ls-0e}'

    ;; sector padding magic...
    times 512-($-$$) db 0