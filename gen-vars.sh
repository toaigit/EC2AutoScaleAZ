source vars.env
cat vars.templ | gomplate > vars.tf
cat backend.templ | gomplate > backend.tf
cat userdata.templ | gomplate > userdata.sh
