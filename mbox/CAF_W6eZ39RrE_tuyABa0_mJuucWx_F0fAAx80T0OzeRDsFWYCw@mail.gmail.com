Return-Path: <carlosmaniero@gmail.com>
Delivered-To: carlos@maniero.me
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
	by fr-int-smtpin8.hostinger.io (mx.hostinger.com) with ESMTPS id 4Zs4gS4Z42z4LNQl
	for <carlos@maniero.me>; Tue, 06 May 2025 04:10:28 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=maniero.me;
	s=hostingermail1; t=1746504628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 dkim-signature; bh=p3dVdk+7H0Aj4dEY/PewDpr5q84ZpzyUhhYi5D/eog8=;
	b=mk3Nam/1Z8n2umKzhDgz18JxnwiV4PB1CFszmkWNpXVZhNcxEQSyQOpQz0hBg5MG0LFRX+
	rBKLO1wrcDxZvpgYldwz/94Im+3gbVEgApc7YMEg3M04yNO9mxQRDXWCYhIoDJOC1p0OS8
	KJ+g856nU6cWhEJiry4vuQ2ct3G2GZso+Pk7nG/RCUFHWQwsZ2xetI+fYikBUaPDWVa1dc
	rJo8mvu8dbEen1bBCH9Itrjt1/UQ+0DXF9pLRFIOvxXHjPqS++HkeysDSdBysRpbmT61hI
	8IhLAc08wfcceHT82UWhfUSW7AFC1YsELnBTpKVyewxydtcqYRebcLI8AHH28w==
ARC-Authentication-Results: i=1;
	fr-int-smtpin8.hostinger.io;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZBq3yi4Q;
	spf=pass (fr-int-smtpin8.hostinger.io: domain of carlosmaniero@gmail.com designates 2a00:1450:4864:20::62e as permitted sender) smtp.mailfrom=carlosmaniero@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=hostingermail1; d=maniero.me; t=1746504628; a=rsa-sha256;
	cv=none;
	b=CTnapJKCEj3ihAHBiwOn6jD1r+KyTQuySqzLOsGhERhR1iUA1LOXoeGbp9tbjok29RgHMS
	67yhC2CCMHASgCMBO04t7ATWnWGyalXaQQSo5Au13MtiNzNzn7A5jC+z/aynrs/x9Di8fK
	tF+qt9Cl2s0dTIi3RMSqqSyfuWdeW0/Bc0cdPFRTz/pWVoeOuJ+vXlJfVrh0TfEgg5+PTu
	cvvxr8H106wM9sGvJiOaIWuInMI42ObVfljYsVAN72uR+Xha5SBE1jGH6ntrgDHdsxY04Z
	mnUrrkgtvxmw6f/cYQarCI2OVRmUqJeSLdORQilav9xS384pDgH6MY+EV1xSVg==
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-ac2ab99e16eso206313566b.0
        for <carlos@maniero.me>; Mon, 05 May 2025 21:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746504627; x=1747109427; darn=maniero.me;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p3dVdk+7H0Aj4dEY/PewDpr5q84ZpzyUhhYi5D/eog8=;
        b=ZBq3yi4Q1DOvH57zE9ebTC3cjbE6mP/QXbNjMScmcQliCxcG/oJQHTvSA5U+IHepMm
         w7/gRw95juQ3Bkn/SwoTZGxvNr/G8rev2/XRhhwrQ1osE5iZP1Jr3t0mvuUsyGsKaPTj
         atyWYWSeFIV69suL+cOm7ylV+K6KSTX+5QegGYBM4TaHCg9AJuCFxubRred7uKUP1PLM
         7YPNKp8maF75k2sg/3pjkQPA2v4fJUFSkD4qYeVL6iOLKf428b8vYjEXTmXgTxhdRxzt
         0l8GmfTUPAL9AMb2Fu/n/YMpCqjWSmxj+Db8krT7oE36fINRrDUMDYIXWHgSwtyPXi0W
         plUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746504627; x=1747109427;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p3dVdk+7H0Aj4dEY/PewDpr5q84ZpzyUhhYi5D/eog8=;
        b=R4iuUwK6grVroThRvacdTobw+KVgMD5q9l8mPqjdEdii88IZVXJxyhWmfclHQKiNhC
         H0HdEsK2dqqctuS1o8OFTLd4tcH5Q4q6iJgvMazfySSwo+KKvDmT6gf+eabdvQUUrfva
         D7m9IyH3XfzdgcDMUkQowKAhQVgbuUKGuSaKXoQ0HB2f9KX9c0oAY2HiCSnh42SZ4+T5
         BMAgoB89BUVQQZwg/siw031cL0NVacqDHM8pysUoUa2kde5Pbq9IR71RzNrK+BNTY0+r
         EEALCZCrmSzAXnPMFyiS1rQ0hYCKm1py6r8P2FjLLqaW3kr17lN3S3LudfPUoDs4NBQ7
         Ealw==
X-Gm-Message-State: AOJu0Yw9E4lSNQdO+bAIfrrfHGE8vaHmHgDI0SaXmDtzeT5ZjD/LHJ/M
	hp3rJNxUt09rov9EKwqgkvoopWiW+kKvlWDiRa1QMvKeytg7tlNlWVlWd2tkxx0VeH8Pdl7BZ9e
	XII2njuvc8jYAzLLhm632J9HxnLABDQ==
X-Gm-Gg: ASbGncu5f0JlT9Wl+bpWKcsCi+w2jOixBk4Aq2vVnV7qJFZ72mZssXQn9WGAdGFpAuu
	8dvNZuLDg1nJpdFDCQZIcoH3Wj1Pig2+KCOIuvoKDNyWBsnjTu+rXZ1qownjI8TBRAn2RRnz0so
	xWSl8VYOmc6ZY9adI1MUDk
X-Google-Smtp-Source: AGHT+IH2X3tDJZRS3Zxu97BVFNo9qhLjGTOsj73J44SLp/lkbTeGgYW6sWDeJoBH8RbSnXxQM3oXDxAd4bvDy3mWXyI=
X-Received: by 2002:a17:906:ef0e:b0:ace:f07b:1c04 with SMTP id
 a640c23a62f3a-ad1a49750bcmr875210566b.27.1746504626851; Mon, 05 May 2025
 21:10:26 -0700 (PDT)
MIME-Version: 1.0
From: Carlos Maniero <carlosmaniero@gmail.com>
Date: Tue, 6 May 2025 01:10:16 -0300
X-Gm-Features: ATxdqUFTaNKkS4OxJS5JluBMU2oqkA4BuAzIWprBtPmG91QhC_8caGGy5XfTPko
Message-ID: <CAF_W6eZ39RrE_tuyABa0_mJuucWx_F0fAAx80T0OzeRDsFWYCw@mail.gmail.com>
Subject: blogpost: Teach More, Abstract Less
To: Carlos Maniero <carlos@maniero.me>
Content-Type: multipart/alternative; boundary="000000000000e1d83806346fcb27"
X-CM-Analysis: v=2.4 cv=Vv1xAP2n c=1 sm=1 tr=0 ts=68198bb4 a=50IBDmW+XAk7fLoyxW9tPg==:617 a=xqWC_Br6kY4A:10 a=dt9VzEwgFbYA:10 a=x7bEGLp0ZPQA:10 a=hLGZJBIvmpkA:10 a=95EFz5htlIgA:10 a=Cfq94UWkQEwjn2OETxkA:9 a=QEXdDO2ut3YA:10 a=Uz9EnhuHEG25YKoRyM-d:22 a=jMROYaktyPko46j5XlsI:22
X-CM-Envelope: MS4xfEOLUgMOgZORGwEJPtu/E2fHDbauGwvdci5qcg/x0dnp2/jNd3/FF5vtQ7kyBZ/hh272Gr4smmPi5ELdK6f+l+qigeDLWE34vKrm9ZBb921Su0106hlS oRI7aH/fTAqZSlXbBW0CLE1GMYXAADv6xIcal3+8IwvtZt1WFLyPmKaHQF87xscIQZw3ZhGqWldTqXbyQ7uEuShfTm2tlmrwq/ct4ah0M4SlHPEi+7y/bL9K

--000000000000e1d83806346fcb27
Content-Type: text/plain; charset="UTF-8"

Testing that the script works with posts that contains special character.

--000000000000e1d83806346fcb27
Content-Type: text/html; charset="UTF-8"

<div dir="auto">Testing that the script works with posts that contains special character.</div>

--000000000000e1d83806346fcb27--
