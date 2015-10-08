gone_box_changes() {
    if [ -z "$1" ]; then
        echo "profile is required"
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "box id is required"
        exit 1
    fi

    profile=${1//\//}
    profilePath=~/.config/profiles/redshift/.$profile
    boxId=$2

    if [ ! -f "$profilePath" ]; then
        echo "profile $profile does not exist"
        exit 1
    fi
    source $profilePath

    query="select * from raw_box where object_id='$boxId' order by updated_at desc;"

    outputPath=~/tmp/redshift
    outputFile=$outputPath/box-$boxId.html

    [ ! -d "$outputPath" ] && mkdir -p $outputPath

    psql -p 5439 -h $REDSHIFT_HOST -U $REDSHIFT_USER -d $REDSHIFT_DB -W -c "$query" -H > $outputFile

    echo $outputFile
}

gone_product_changes() {
    if [ -z "$1" ]; then
        echo "profile is required"
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "product id is required"
        exit 1
    fi

    profile=${1//\//}
    profilePath=~/.config/profiles/redshift/.$profile
    productId=$2

    if [ ! -f "$profilePath" ]; then
        echo "profile $profile does not exist"
        exit 1
    fi
    source $profilePath

    query="select * from raw_product where object_id='$productId' order by updated_at desc;"

    outputPath=~/tmp/redshift
    outputFile=$outputPath/product-$productId.html

    [ ! -d "$outputPath" ] && mkdir -p $outputPath

    psql -p 5439 -h $REDSHIFT_HOST -U $REDSHIFT_USER -d $REDSHIFT_DB -W -c "$query" -H > $outputFile

    echo $outputFile
}

gone_user_changes() {
    if [ -z "$1" ]; then
        echo "profile is required"
        exit 1
    fi

    if [ -z "$2" ]; then
        echo "user id is required"
        exit 1
    fi

    profile=${1//\//}
    profilePath=~/.config/profiles/redshift/.$profile
    userId=$2

    if [ ! -f "$profilePath" ]; then
        echo "profile $profile does not exist"
        exit 1
    fi
    source $profilePath

    query="select * from raw_user where object_id='$userId' order by updated_at desc;"

    outputPath=~/tmp/redshift
    outputFile=$outputPath/user-$userId.html

    [ ! -d "$outputPath" ] && mkdir -p $outputPath

    psql -p 5439 -h $REDSHIFT_HOST -U $REDSHIFT_USER -d $REDSHIFT_DB -W -c "$query" -H > $outputFile

    echo $outputFile
}