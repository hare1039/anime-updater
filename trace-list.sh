#!/usr/local/bin/bash
source ${HOME}/.bash_profile
megadl_from()
{
    echo "downloading: $1"
    if megadl $1 3>&1 1>&2 2>&3 3>&- | grep -q 'ENOENT'; then
	result=${PWD##*/};
	line "$result dl failed. Please renew the url."
	echo "$result download failed. Please renew the url."
    fi
}

cd /mnt/NAS/video/#連載中/三月的獅子2 && 
megadl_from 'https://mega.nz/#F!4q4xyaTS!0Ezx5cKCmmReHzmWOHSE4A';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/童話魔法使' &&
megadl_from 'https://mega.nz/#F!lXYx3CrD!LU8mavnYWJDqlhsxwNLNcw' &&
megadl_from 'https://mega.nz/#F!mRhE1BbJ!gvJWTeABXmMvnN8E1mnZ1g';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/Slow Start' &&
megadl_from 'https://mega.nz/#F!ZSBCARjQ!lr4EIJwzNg83Q72qOYqdbA';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/粗點心戰爭2' &&
megadl_from 'https://mega.nz/#F!DdAX3KAa!IYLZlgt9yNTGxNPEf2zQTg';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/デスマーチからはじまる異世界狂想曲' &&
megadl_from 'https://mega.nz/#F!vExiTaLb!ii0cF8C41EULzNTGgn0EQA';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/からかい上手の高木さん' &&
megadl_from 'https://mega.nz/#F!9T5GXQxb!JVIUSgA_Q4Yxgy2_QwHKfA';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/庫洛魔法使 透明牌篇' &&
megadl_from 'https://mega.nz/#F!f08B1CRA!ML5OO0ODFM4gbOcWJXSeAQ' &&
megadl_from 'https://mega.nz/#F!25Vh1QKB!-_aNjFO76mgLIeBhNo68SQ';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/ラーメン大好き小泉さん' &&
megadl_from 'https://mega.nz/#F!bFIgQQSZ!d9SVLm6ff4Ma7O4Iwt0OHQ';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/citrus' &&
megadl_from 'https://mega.nz/#F!qUoilAxA!rYSaMG9XskwYSPvsASNVhQ';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/魔法使的新娘' &&
megadl_from 'https://mega.nz/#F!68sA2Q6C!tBElgJtUgzF-7G89Z2L3Wg';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/比宇宙更遠的地方' &&
megadl_from 'https://mega.nz/#F!oGp3zRCK!OdHtWincbaHusAzWsGUKvA';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/搖曳露營' &&
megadl_from 'https://mega.nz/#F!7A5VXRYZ!n8IgFYSCcRUWsJ8BDW3pew' &&
megadl_from 'https://mega.nz/#F!3RAlDKzQ!eO4jmAgNYZcaHjZV0onuNA';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/龍王的工作' &&
megadl_from 'https://mega.nz/#F!3Bg02QrL!pQOiI3r7QCoFoxxuvn5Feg';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/博多豚骨ラーメンズ' &&
megadl_from 'https://mega.nz/#F!adgXFZDQ!_lnX2p-ZktINPMh1k_kwJg';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/刻刻' &&
megadl_from 'https://mega.nz/#F!fcZDWTgT!789gbiFh7MoZAmw_FAZc2A';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/DARLING in the FRANXX' && 
megadl_from 'https://mega.nz/#F!DYwVGbTY!us3bVpHkt06IE6VrecB8sQ' &&
megadl_from 'https://mega.nz/#F!CIpRQDDI!A6kz67aSzRhDJEV4G7-IWg';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/紫羅蘭永恆花園' && 
megadl_from 'https://mega.nz/#F!6AZy1YxB!UC9CHe2BHYfGdjMXgtQ99g';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/沒有心跳的少女 BEATLESS' &&
megadl_from 'https://mega.nz/#F!OZRGATKS!0QSNkWZBjK49VV-BjL9-eA';
find . -type f -size 0 -delete;

cd '/mnt/NAS/video/#連載中/戀は雨上がりのように' &&
megadl_from 'https://mega.nz/#F!iExDkJCJ!-FDjREAbo3GMQZOAXc_q1w';
find . -type f -size 0 -delete;

cd '/mnt/NAS/NFS/hare1039/download' &&
megadl_from 'https://mega.nz/#!SNJzSLbQ!sVLHGrEr71E2utUI1ZJGvVlDgK6qGVM7M_jffYcEM7o';
find . -type f -size 0 -delete;

cd '/mnt/NAS/E_drive/これは・・あなただけですよ/bt/animation' &&
# germany1301@eyny獨家
megadl 'https://mega.nz/#!syozjZTb!JGW8KeW9FvvLKe2xL9I-PbIHhkTSGrTh3SIfAGvNcqg' &&
megadl 'https://mega.nz/#!Hl51yY6C!quQXY74GYa3JKokyAUV8P38WRKUd1jNXO9bbUGB0S1o' &&
megadl 'https://mega.co.nz/#!4FRxXRwa!4oL3GgGDkIHw4lYGCQxq4hnfMQE8U0gWB2HiuqtdMjA' &&
megadl 'https://mega.co.nz/#!44Fz0KJa!95B7-A8z-qFfRJh86MW2pChqZgqo301k6iQ_DDIn-cg' &&
megadl 'https://mega.nz/#!4SwC3bTL!eKT17a4pwQj6Fwtx4IBBZwOgL22XYi0h7Cub2oEPeVk' &&
megadl 'https://mega.nz/#!ZOpCwLpL!5gRGnSQupe1qBaYLgD8WYjd0X9LEt40TSXGpmz5rPaI';
find . -type f -size 0 -delete; 


# cd '/mnt/NAS/video/hare/いつか天魔の黒ウサギ' &&
# megadl_from 'https://mega.co.nz/#F!5MpnhT7Q!ONJQbF3nzuAaM6-ZVYDWmA' &&
# megadl_from 'https://mega.co.nz/#F!sE5yjCxb!GYJ1tApzbsRuTQUyQGRhCg';
# find . -type f -size 0 -delete;
# cd '/mnt/NAS/NFS/hare1039/shirobako' &&
# megadl_from 'https://mega.nz/#F!qhtGABTZ!qbd8u6qXpok7IuzFjQXtsw';
# find . -type f -size 0 -delete;
# # 7040709
# # stevenweng09&70407axd@share
# cd '/mnt/NAS/video/hare/徒然喜歡你' &&
# megadl_from 'https://mega.nz/#F!KZsUmB4A!0ckLChMALkVDzRW4DNyo5A';
# find . -type f -size 0 -delete;

# cd '/mnt/NAS/video/hare/F.AP' && 
# megadl_from 'https://mega.nz/#F!LNIV3Awa!ltVjBFeDogtyjtcpnKwQFw';
# megadl_from 'https://mega.nz/#F!uNIxSZrC!QyX4CLbxI-GF7OMmJSGJPA';
# megadl_from 'https://mega.nz/#F!Ni42iBKK!eFkIKC4W8xOeUjzlf5bSOQ';
# find . -type f -size 0 -delete;

# cd '/mnt/NAS/video/hare/庫洛魔法使/01-46' &&
# megadl_from 'https://mega.co.nz/#F!EpQQWYwJ!TXWxUwErk49_mfVfGF-WcQ';
# find . -type f -size 0 -delete;
# 
# cd '/mnt/NAS/video/hare/庫洛魔法使/47-70' &&
# megadl_from 'https://mega.co.nz/#F!dwZnkbzQ!MPIDgkegxmFeag6XGoV9Ag';
# find . -type f -size 0 -delete;
# 
# cd '/mnt/NAS/video/hare/庫洛魔法使/劇場版' &&
# megadl_from 'https://mega.co.nz/#F!tpYyjQ5B!VvV9QEh_9FYW7HUkfp7jkg';
# megadl_from 'https://mega.co.nz/#F!g95nkaaZ!CALWFTJx2Y1jKIkyWqR_8Q';
# find . -type f -size 0 -delete;
# cd /mnt/NAS/video/#連載中/側車搭檔 &&
# megadl_from 'https://mega.nz/#F!wax0ia5J!oLRMhBZ4ay8kMDDY9f9AfQ';
# find . -type f -size 0 -delete;
# cd /mnt/NAS/video/#連載中/動畫同好會 &&
# megadl_from 'https://mega.nz/#F!QSA3ASJA!fqigWX_9vuEw7JdZZvs42Q';
# find . -type f -size 0 -delete;
# cd '/mnt/NAS/video/#連載中/補/裙下的野獸' &&
# megadl_from 'https://mega.nz/#F!fYZkgZgb!Y5Nk7runzh_7i6l5JQM4KA';
# find . -type f -size 0 -delete;
# cd '/mnt/NAS/video/#連載中/補/相親對象是我教的強勢問題兒' &&
# megadl_from 'https://mega.nz/#F!p2Rj3LIJ!4mV-dHs1i14ltlRUWGWHuQ';
# find . -type f -size 0 -delete;
# cd '/mnt/NAS/video/hare/幻靈鎮魂曲' &&
# megadl_from 'https://mega.nz/#F!Rg1BiDCK!ORTGwnJb46otCc4pZDARlg';
# # password : lovelove221@伊莉獨家
# find . -type f -size 0 -delete;
