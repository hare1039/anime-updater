#!/usr/local/bin/bash

trace_file=${HOME}/Documents/git_projects/mega-trace/rate.txt;
instance_sub()
{
    rate=$(cat ${trace_file});
    if [ $rate -eq "0" ]; then
	echo "Too meny mega instences. Skip.";
	exit 0;
    fi
    # ok, instence - 1
    let "rate = $rate - 1";
    echo $rate > ${trace_file};
}
instance_plus()
{
    rate=$(cat ${trace_file});
    # instence + 1
    let "rate = $rate + 1";
    echo $rate > ${trace_file};
}

source ${HOME}/.bash_profile
export LC_ALL=zh_TW.UTF-8
instance_sub;
trap instance_plus EXIT;

megadl_from()
{
    title=${PWD##*/};
    echo "downloading: $title";
    mega_result=$(megadl --no-progress --print-names $* 2>&1);
    if grep -q 'ENOENT' <<< "$mega_result" ; then
	line "$title dl failed. Please renew the url.";
	echo "$title download failed. Please renew the url.";
    fi
    if grep -q -v 'ERROR' <<< "$mega_result"; then
	rawname=$(grep -v 'ERROR' <<< "$mega_result");
#	filename=$(basename ${rawname});
	while read -r line; do
	    filename="$filename        ${line##*/}";
	done <<< "$rawname";
	line "$title have updated.,$filename have been downloaded.";
	echo "$title have updated";
    fi
#    echo $mega_result > re.txt;
    if grep -q "509" <<< "$mega_result"; then
        echo "509!";
    fi
    find . -type f -size 0 -delete;
}
# unit test #1: ENOENT
# megadl_from 'https://mega.co.nz/#F!d8RR0RJJ!bdlyZny9iFwJxH2CfXnNTQ';
cd '/mnt/NAS/video/#連載中/三月的獅子2';
megadl_from 'https://mega.nz/#F!W8FBjaZI!fIupLoVihVPMrN3TUdBIaQ';

cd '/mnt/NAS/video/#連載中/童話魔法使';
megadl_from 'https://mega.nz/#F!lXYx3CrD!LU8mavnYWJDqlhsxwNLNcw';
megadl_from 'https://mega.nz/#F!mRhE1BbJ!gvJWTeABXmMvnN8E1mnZ1g';

cd '/mnt/NAS/video/#連載中/Slow Start';
megadl_from 'https://mega.nz/#F!ZSBCARjQ!lr4EIJwzNg83Q72qOYqdbA';
megadl_from 'https://mega.nz/#F!TBoGARqB!VYZr8VKHTrZmZtcWMo5DMA';

cd '/mnt/NAS/video/#連載中/粗點心戰爭2';
megadl_from 'https://mega.nz/#F!DdAX3KAa!IYLZlgt9yNTGxNPEf2zQTg';

cd '/mnt/NAS/video/#連載中/デスマーチからはじまる異世界狂想曲'
megadl_from 'https://mega.nz/#F!OQhQlJ5Q!gFuJ8y19pXdRxlzH9fpTIg';
megadl_from 'https://mega.nz/#F!vExiTaLb!ii0cF8C41EULzNTGgn0EQA';

cd '/mnt/NAS/video/#連載中/からかい上手の高木さん'
megadl_from 'https://mega.nz/#F!9T5GXQxb!JVIUSgA_Q4Yxgy2_QwHKfA';

cd '/mnt/NAS/video/#連載中/比宇宙更遠的地方'
megadl_from 'https://mega.nz/#F!PMZAVA7Z!1xxno-iHNV6MRbTiS7Khsg';

cd '/mnt/NAS/video/#連載中/庫洛魔法使 透明牌篇';
megadl_from 'https://mega.nz/#F!f08B1CRA!ML5OO0ODFM4gbOcWJXSeAQ';
megadl_from 'https://mega.nz/#F!25Vh1QKB!-_aNjFO76mgLIeBhNo68SQ';

cd '/mnt/NAS/video/#連載中/ラーメン大好き小泉さん';
megadl_from 'https://mega.nz/#F!bFIgQQSZ!d9SVLm6ff4Ma7O4Iwt0OHQ';

cd '/mnt/NAS/video/#連載中/citrus';
megadl_from 'https://mega.nz/#F!qUoilAxA!rYSaMG9XskwYSPvsASNVhQ';

cd '/mnt/NAS/video/#連載中/魔法使的新娘';
megadl_from 'https://mega.nz/#F!68sA2Q6C!tBElgJtUgzF-7G89Z2L3Wg';

cd '/mnt/NAS/video/#連載中/搖曳露營';
megadl_from 'https://mega.nz/#F!7A5VXRYZ!n8IgFYSCcRUWsJ8BDW3pew';
megadl_from 'https://mega.nz/#F!3RAlDKzQ!eO4jmAgNYZcaHjZV0onuNA';

cd '/mnt/NAS/video/#連載中/龍王的工作';
megadl_from 'https://mega.nz/#F!3Bg02QrL!pQOiI3r7QCoFoxxuvn5Feg';

cd '/mnt/NAS/video/#連載中/博多豚骨ラーメンズ';
megadl_from 'https://mega.nz/#F!adgXFZDQ!_lnX2p-ZktINPMh1k_kwJg';

cd '/mnt/NAS/video/#連載中/刻刻';
megadl_from 'https://mega.nz/#F!fcZDWTgT!789gbiFh7MoZAmw_FAZc2A';

cd '/mnt/NAS/video/#連載中/DARLING in the FRANXX'; 
megadl_from 'https://mega.nz/#F!DYwVGbTY!us3bVpHkt06IE6VrecB8sQ';
megadl_from 'https://mega.nz/#F!CIpRQDDI!A6kz67aSzRhDJEV4G7-IWg'; 
megadl_from 'https://mega.nz/#F!ndhW1DiQ!jULC0_GPuNhgftN5r_R_Og';
megadl_from 'https://mega.nz/#F!PAhViKAb!RRhMlwl-ZPaTR5jXaJTUGA';

cd '/mnt/NAS/video/#連載中/紫羅蘭永恆花園'; 
megadl_from 'https://mega.nz/#F!6AZy1YxB!UC9CHe2BHYfGdjMXgtQ99g';

cd '/mnt/NAS/video/#連載中/沒有心跳的少女 BEATLESS';
megadl_from 'https://mega.nz/#F!OZRGATKS!0QSNkWZBjK49VV-BjL9-eA';

cd '/mnt/NAS/video/#連載中/戀は雨上がりのように';
megadl_from 'https://mega.nz/#F!iExDkJCJ!-FDjREAbo3GMQZOAXc_q1w';

# cd '/mnt/NAS/E_drive/w700desktop/w面白い/#完食/のんのんびより/Season1';
# megadl_from 'https://mega.co.nz/#F!8wgxlQ7D!YWAhEGgLa3dA5oU3NcSnTQ';
# 
# cd '/mnt/NAS/E_drive/w700desktop/w面白い/#完食/のんのんびより/Season2';
# megadl_from 'https://mega.co.nz/#F!3N1UQJCK!4cQ7ln11t9w-xOl61xFPwg';


# cd '/mnt/NAS/NFS/hare1039/download';
# megadl_from 'https://mega.nz/#!SNJzSLbQ!sVLHGrEr71E2utUI1ZJGvVlDgK6qGVM7M_jffYcEM7o';

# cd '/mnt/NAS/E_drive/これは・・あなただけですよ/bt/animation';
# # germany1301@eyny獨家
# megadl_from 'https://mega.nz/#!syozjZTb!JGW8KeW9FvvLKe2xL9I-PbIHhkTSGrTh3SIfAGvNcqg';
# megadl_from 'https://mega.nz/#!Hl51yY6C!quQXY74GYa3JKokyAUV8P38WRKUd1jNXO9bbUGB0S1o';
# megadl_from 'https://mega.co.nz/#!4FRxXRwa!4oL3GgGDkIHw4lYGCQxq4hnfMQE8U0gWB2HiuqtdMjA';
# megadl_from 'https://mega.co.nz/#!44Fz0KJa!95B7-A8z-qFfRJh86MW2pChqZgqo301k6iQ_DDIn-cg';
# megadl_from 'https://mega.nz/#!4SwC3bTL!eKT17a4pwQj6Fwtx4IBBZwOgL22XYi0h7Cub2oEPeVk';
# qmegadl_from 'https://mega.nz/#!ZOpCwLpL!5gRGnSQupe1qBaYLgD8WYjd0X9LEt40TSXGpmz5rPaI';

# cd '/mnt/NAS/E_drive/kこれは・・あなただけですよ/15とうり/#new/革命機Valvrave';
# megadl_from 'https://mega.co.nz/#F!KBVwCLDa!xGjgOMgHo4NMLMGtSdVGSA';
# 

# cd '/mnt/NAS/E_drive/これは・・あなただけですよ/15とうり/#new/妳是主人我是僕/';
# megadl_from 'https://mega.nz/#F!xp0j3CQC!z8W5FLpUKGHdI2p_7k3bKg';

# cd '/mnt/NAS/video/hare/魔王勇者';
# megadl_from 'https://mega.co.nz/#F!0YICRCqI!tKm0Yh2hbeFaeleE2f2yfg';
# # 劇情老套了啦

# cd '/mnt/NAS/video/hare/いつか天魔の黒ウサギ';
# megadl_from 'https://mega.co.nz/#F!5MpnhT7Q!ONJQbF3nzuAaM6-ZVYDWmA';
# megadl_from 'https://mega.co.nz/#F!sE5yjCxb!GYJ1tApzbsRuTQUyQGRhCg';
# 
# cd '/mnt/NAS/NFS/hare1039/shirobako';
# megadl_from 'https://mega.nz/#F!qhtGABTZ!qbd8u6qXpok7IuzFjQXtsw';
# 
# # 7040709
# # stevenweng09&70407axd@share
# cd '/mnt/NAS/video/hare/徒然喜歡你';
# megadl_from 'https://mega.nz/#F!KZsUmB4A!0ckLChMALkVDzRW4DNyo5A';
# 

# cd '/mnt/NAS/video/hare/F.AP'; 
# megadl_from 'https://mega.nz/#F!LNIV3Awa!ltVjBFeDogtyjtcpnKwQFw';
# megadl_from 'https://mega.nz/#F!uNIxSZrC!QyX4CLbxI-GF7OMmJSGJPA';
# megadl_from 'https://mega.nz/#F!Ni42iBKK!eFkIKC4W8xOeUjzlf5bSOQ';
# 

# cd '/mnt/NAS/video/hare/庫洛魔法使/01-46';
# megadl_from 'https://mega.co.nz/#F!EpQQWYwJ!TXWxUwErk49_mfVfGF-WcQ';
# 
# 
# cd '/mnt/NAS/video/hare/庫洛魔法使/47-70';
# megadl_from 'https://mega.co.nz/#F!dwZnkbzQ!MPIDgkegxmFeag6XGoV9Ag';
# 
# 
# cd '/mnt/NAS/video/hare/庫洛魔法使/劇場版';
# megadl_from 'https://mega.co.nz/#F!tpYyjQ5B!VvV9QEh_9FYW7HUkfp7jkg';
# megadl_from 'https://mega.co.nz/#F!g95nkaaZ!CALWFTJx2Y1jKIkyWqR_8Q';
# 
# cd /mnt/NAS/video/#連載中/側車搭檔;
# megadl_from 'https://mega.nz/#F!wax0ia5J!oLRMhBZ4ay8kMDDY9f9AfQ';
# 
# cd /mnt/NAS/video/#連載中/動畫同好會;
# megadl_from 'https://mega.nz/#F!QSA3ASJA!fqigWX_9vuEw7JdZZvs42Q';
# 
# cd '/mnt/NAS/video/#連載中/補/裙下的野獸';
# megadl_from 'https://mega.nz/#F!fYZkgZgb!Y5Nk7runzh_7i6l5JQM4KA';
# 
# cd '/mnt/NAS/video/#連載中/補/相親對象是我教的強勢問題兒';
# megadl_from 'https://mega.nz/#F!p2Rj3LIJ!4mV-dHs1i14ltlRUWGWHuQ';
# 
# cd '/mnt/NAS/video/hare/幻靈鎮魂曲';
# megadl_from 'https://mega.nz/#F!Rg1BiDCK!ORTGwnJb46otCc4pZDARlg';
# # password : lovelove221@伊莉獨家
# 
# cd '/mnt/NAS/video/hare/結界師';
# megadl_from "https://mega.co.nz/#!UQpURTDT!Pl0zT2i2NgVJWrtxPJlYZ0ESm450DVf-B1Bk7FXZb8c" 
# megadl_from "https://mega.co.nz/#!4MoVjbrK!GKdiuXn73l51d1eSIovyumSIHbZtNGGrYDk6_Soua8Y" 
# megadl_from "https://mega.co.nz/#!UV4DiBYZ!U0-810dPydwDHJZr16qxfXmzuXImN2vzNM96sr5RJJ4" 
# megadl_from "https://mega.co.nz/#!VcRlBIDZ!Coa7A2J01S7QLMnRPIsoESrB6UZtUmJEm8CMHWMfXy0" 
# megadl_from "https://mega.co.nz/#!dM4HHBbQ!dn0ynRmFq9_K84hnO2h44mziK7A3uE34rDTqFBMrfk4" 
# megadl_from "https://mega.co.nz/#!Rcp0SCSL!Ou6-UzJana7GAjhGFxdC7ws6b2VLWNmHuyUYYULDFl8" 
# megadl_from "https://mega.co.nz/#!xdBwiCKA!CIAFpFxNFTyOIJ0uUZttYQnTa8lPQUXYheAeDizCLdg" 
# megadl_from "https://mega.co.nz/#!MUQiWCKL!GHIEIzWhKlzqxpl5X5yFN0sDOJ0JYbWc0pJDyUkwSd8" 
# megadl_from "https://mega.co.nz/#!9MYHRKxI!GUA0CHqFRCjs3B3dv4r4KR8oIcBnSeJSmlQm9ZH-2Ww" 
# megadl_from "https://mega.co.nz/#!hFBQDKbD!XAJa5kd7Ng1VxtqDTcX-bWuYP7UttLijIsRIbjEijcU" 
# megadl_from "https://mega.co.nz/#!sQ4GWRyK!ZDvd0X7bCK8ek8kPlsja2F395G0WmippK_5JpbDQR4U" 
# megadl_from "https://mega.co.nz/#!cYxyzbCb!LvZ3PFKsR3nE9eSyPPndvG7A4IdLVululatUdyhc-6c" 
# megadl_from "https://mega.co.nz/#!kVgWRShA!Qk_mPlcHJYbairSn77r_D136xixdl0xC20d9KcXBcpE" 
# megadl_from "https://mega.co.nz/#!IF5kgRLI!ChjsVXiNnzE6ZIBh4Sd1vDQDpbQ9WzNlJPRwHbaW7H8" 
# megadl_from "https://mega.co.nz/#!VNokTRTT!W-ajiXVICzgNKImPE_w3dH651mltkw78QhjHqGoXMt8" 
# megadl_from "https://mega.co.nz/#!pV5D2CSa!TRR8wWjaM2-yIlVPRnYeeXnCAJdf77f3ydGOdyXiQ3U" 
# megadl_from "https://mega.co.nz/#!9UoDkKwY!WbSwczwTXf3B32eYelK1-n5yO0VrFjibz7AloHFT04A" 
# megadl_from "https://mega.co.nz/#!FZpwEYAS!blxFY3ZiNCs5qNcyxDhz_TutRrMoqPNpLXlbVp2qpBo" 
# megadl_from "https://mega.co.nz/#!tIoQUI7C!TzJbFXI-fBkmzjtcZTB9UjxQvaZiSf0pPp_VojBfT9E" 
# megadl_from "https://mega.co.nz/#!xBBX3LzC!dWZN9wGJvVC3Ei0ax1U34EpDkxQzUq3A1xB1FoE0xv0" 
# megadl_from "https://mega.co.nz/#!ME51FZaI!DUZgOiR2prlMiUW71g2B-3NfLn9jXQK0Md4igafqkyo" 
# megadl_from "https://mega.co.nz/#!wYAQwB4S!M5JmoiGusJdif0gcKq4hnUZN5TQtUK2QJQinUw176a8" 
# megadl_from "https://mega.co.nz/#!dMBQTSRZ!C3Vj2XvWk9rqGhASN45rEi0t011HiTUS170d3BcWEzU" 
# megadl_from "https://mega.co.nz/#!AdRXDK5B!BjHduEmLsybQo__NFIeyzDeNiK4vRlye8HwFeDxcMt8" 
# megadl_from "https://mega.co.nz/#!UVghlCxJ!S0DmfWMXlLDafn62L0DuDC_Rb9I1Evpa7nNpPj3l5oQ" 
# megadl_from "https://mega.co.nz/#!sBRExBRa!Pr7XYQfz_pu_lDkJIHN7V17_n0NzouItnrZPH0PkqfU" 
# megadl_from "https://mega.co.nz/#!IVJgSSYR!XwiGJE_QTMEeL9XyWEo_6RC9855a_XbhN7kjig-cQvM" 
# megadl_from "https://mega.co.nz/#!EMw0RSBC!cwWi5VGdH2hHG0B3nXGXMTM1zC4CHrXUR7PHD96tj4w" 
# megadl_from "https://mega.co.nz/#!NMQWGS4A!RhL843bDjT365bvxC3KXAiOD0VhWM2pz96Do0VYKUM8" 
# megadl_from "https://mega.co.nz/#!1IQFFYpD!CEeX3iQO8It8xfAWKOwQLxykeW8FVkjAJ13ObHO3mk0" 
# megadl_from "https://mega.co.nz/#!pJ5nFbJK!CrF-rDxkB_K8UbIP6WO7IGE8Bh1L2GQM3dTJGcRiG1U" 
# megadl_from "https://mega.co.nz/#!NdwSGToT!LQxYqRFEaWrrr796s1RWoTNmUp5x08Eq5y2liq4QmWU" 
# megadl_from "https://mega.co.nz/#!RUYjlIYY!ZhSflEzikA0S4CwJ21Hy51miP7kyDrjReoXKn4pKdjU" 
# megadl_from "https://mega.co.nz/#!oYAHzRoQ!Gzr7inQrFDiRauCCbVDprnZcrWlLV1xvq616fzVTe-w" 
# megadl_from "https://mega.co.nz/#!wFxHBYAC!TxUAnlEQCu_mu2UVkSZ7Lm-88NsaUOWusRNLsLKdMkw" 
# megadl_from "https://mega.co.nz/#!5IAAiYqC!IPB_bjws2KDLG_9KB-p1kV7j9Xd8_b82opZm3WPO7oE" 
# megadl_from "https://mega.co.nz/#!lN43jQyJ!O3Rzxwx8yFMKwbIj8GjADRoiQKRKPli6HdFBRvjtR-M" 
# megadl_from "https://mega.co.nz/#!hVInHQzL!XEqVWRmRTCjz8CTFg5qa4VEwcY9C50Kxzlg8C7gRwd4" 
# megadl_from "https://mega.co.nz/#!sE5jHZZZ!A7d8D0Zhy-ee2vGvrlznWzaFXrU2AxNC1I-5z-eQBxc" 
# megadl_from "https://mega.co.nz/#!FAJW2JhQ!Slpqfl-oyf38AVkH7zjorh1q09FvWvxK83g-obkWG2E" 
# megadl_from "https://mega.co.nz/#!ZIYSzCLY!D7h5yAl4n38EMxyhdu40Nxw_kjsXemgGeJzleUKAxGY" 
# megadl_from "https://mega.co.nz/#!tIoUxZjb!eAp5B2GPfD4lWkkuA_9tx2wFXLtEL-UxG5EaTCU0mpM" 
# megadl_from "https://mega.co.nz/#!BRRCFZRY!GohQemr9Af_kFtmvTmqduEWHcoAtBscTyd5_wRGLBYM" 
# megadl_from "https://mega.co.nz/#!QNRk2DZC!bYQGLEPGbOz0JxgQ2y2eim1RE9FCTMHamoADaeIzAek" 
# megadl_from "https://mega.co.nz/#!xc52SBJI!M5p1DxA9OcNLMFKkR-iWWTFC6NF2t7GyI3rHIl5qFmk" 
# megadl_from "https://mega.co.nz/#!sRxlhQyL!ZuYozTlqnxppTK0_nQk49iOcHQ5QwWJTX5r2mslh7VQ" 
# megadl_from "https://mega.co.nz/#!EV5AhAyJ!WobHQmvCkByG1oaavVgHe2HwEYVMEujoyH1TrOILIdQ" 
# megadl_from "https://mega.co.nz/#!8VgBkQyZ!YF0CLiCuPUQxZYLyvKhjlWQ6zgU-BI6iNc9nqqZS-FA" 
# megadl_from "https://mega.co.nz/#!0BpnHZaL!TZR_TFSsyJIVx_hSliVqVQrIinNKdKDtTpJ18ZrdLlw" 
# megadl_from "https://mega.co.nz/#!RYQWgTbL!cU6Dg0rERdXson2HTasr1VqaV8FRS2vu1xb8OVqk3j8" 
# 
