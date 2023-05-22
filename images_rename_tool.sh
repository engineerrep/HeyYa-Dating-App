
# 该脚本把运行路径下的子文件夹中的图片拷贝到相应位置
# 比如在assets/images目录下运行该脚本


#!bin/sh

cd assets/images

for file in ./*
do
    if test -f $file
    then
        echo 文件名: $file
    fi
    if test -d $file
    then
    	echo ''
    	echo ''
        # echo 目录名: $file
        cd $file
        pwd
        
        #TODO：如果没有3.0x文件夹,则手动创建
        mkdir -p 3.0x
        mkdir -p 2.0x

        touch test@2x.png
        touch test@3x.png

        mv ./*@3x.png 3.0x/
        mv ./*@2x.png 2.0x/ 

        
        cd 3.0x
        rm test@3x.png
        rename * -f -d "@3x"

        cd ../2.0x
        rm test@2x.png
        rename * -f -d "@2x"
        echo $file folder rename success
        cd ..
        cd ..
    fi
done


