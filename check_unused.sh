#!/bin/bash
####################################################
##一度も使用されていないelementとimgを一括検索する処理
##CakePHP1の場合は第1引数1

##CakePHP2の場合は第1引数2

##CakePHP3の場合は第1引数3

##         両方実行したい場合は第2引数0

##         elementだけ実行したい場合は第2引数1

##         imgだけ実行したい場合は第2引数2

##         例：CakePHP1でimgだけ検索したい場合
##             bash ~/sample.sh 1 2
####################################################
echo "検索したいディレクトリを入力"   #app_clinicなど
read dir

#入力されたディレクトリがあるか確認
if [ ! -d $dir ]; then
	echo "存在しないディレクトリです"
	exit
fi

cd $dir

#############################################エレメントの検索#############################################
if [ $2 != 2 ]; then
	#エレメントのディレクトリを検索
	#cake1
	if [ $1 = 1 ]; then
		elementDirName='elements'
	elif [ $1 = 2 ]; then
		elementDirName='Elements'
	elif [ $1 = 3 ]; then
		elementDirName='Element'
	fi

	elementsDir=`find ./ -name ${elementDirName} -type d`

	elementNotUsedCountArray=()
	elementsDirSum=`find ${elementsDir[0]:2} -type f | wc -l`

	echo "--------------------------------------検索を開始します--------------------------------------"

	i=1
	#element内のファイルのパスを取得
	for elementFileName in `find ${elementsDir:2} -type f | sort`
	do
	   #./と拡張子を削除
	   searchFileNameForGrep=`echo "$elementFileName" | sed -e "s/^.*${elementDirName}\/\(.*\).ctp/\1/"`
	   #searchFileNameForGrep=`echo "$elementFileName" | sed -e "s/^.*elements\/\(.*\).ctp/\1/"`

	   echo "--------------------------------------${i}/${elementsDirSum}--------------------------------------"
	   let i++

	   echo $searchFileNameForGrep
	   #最初に入力されたディレクトリ下のview内をgrep
		if [ $1 = 1 ]; then
			viewDirName='views'
		elif [ $1 = 2 ]; then
			viewDirName='View'
		elif [ $1 = 3 ]; then
			viewDirName='src/View'
		fi

	   count=`grep -rl ${searchFileNameForGrep} ${viewDirName}/ | wc -l`
	   echo "${count}件"

	   if [ $count = '0' ]; then
	      elementNotUsedCountArray+=($searchFileNameForGrep)
	   fi
	done

	echo "--------------------------------------検索を終了します--------------------------------------"

	#配列に一つでも入っていれば、ファイルに出力する
	if [ ${#elementNotUsedCountArray[@]} -gt 0 ]; then
	   touch check_element_count.txt
	   for file in "${elementNotUsedCountArray[@]}"
	   do
		   echo $file
	      echo ${file} >> check_element_count.txt
	   done
	fi

	echo "--------------------------------------${#elementNotUsedCountArray[@]}件ヒットしました--------------------------------------"
fi

#############################################画像の検索#############################################
if [ $2 != 1 ]; then

	#webroot以下のimgディレクトリを検索
	if [ $1 = 1 ]; then
		searchImgDirPath='./webroot/theme'
	else
		searchImgDirPath='./webroot'
	fi

	imageDirs=(`find ${searchImgDirPath} -name "img" -type d`)

	imageDirs=`find ./webroot -name "img" -type d`

	imgFileNameArray=()
	imgNotUsedCountArray=()

	imageDirSum=`find ${imageDirs[0]:2} -type f | wc -l`

	echo "--------------------------------------検索を開始します--------------------------------------"

	i=1
	for imgFileNamePath in `find ${imageDirs[0]:2} -type f | sort`
	do
	   imgFileNameForGrep=`echo "$imgFileNamePath" | sed -e "s/^.*img\/\(.*\)/\1/"`

	   echo "--------------------------------------${i}/${imageDirSum}--------------------------------------"
	   let i++

	   echo $imgFileNameForGrep
	   #最初に入力されたディレクトリ下をgrep
	   count=`grep -rl ${imgFileNameForGrep} | wc -l`   #views以下以外なら正確？
	   echo "${count}件"
	  if [ $count = '0' ]; then
	    imgNotUsedCountArray+=($imgFileNameForGrep)
	  fi
	done

	echo "--------------------------------------検索を終了します--------------------------------------"

	#配列に一つでも入っていれば、ファイルに出力する
	if [ ${#imgNotUsedCountArray[@]} -gt 0 ]; then
		touch check_image_count.txt
		for file in "${imgNotUsedCountArray[@]}"
		do
			echo ${file} >> check_image_count.txt
		done
	fi
	echo "--------------------------------------${#imgNotUsedCountArray[@]}件ヒットしました--------------------------------------"
fi
