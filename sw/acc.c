#include <linux/module.h>
#include <linux/init.h>
#include <linux/errno.h>
#include <linux/version.h>
#include <linux/kernel.h>
#include <linux/platform_device.h>
#include <linux/miscdevice.h>
#include <linux/slab.h>
#include <linux/io.h>
#include <linux/of.h>
#include <linux/of_address.h>
#include <linux/fs.h>
#include <linux/uaccess.h>
#include "acc.h"

#define DRIVER_NAME "acc"

#define HASHW0(x) (x)
#define HASHW1(x) (x+1)
#define HSAHW2(x) (x+2)
#define HSAHW3(x) (x+3)
#define HSAHW4(x) (x+4)
#define HSAHW5(x) (x+5)
#define HSAHW6(x) (x+6)
#define HSAHW7(x) (x+7)
#define HSAHW8(x) (x+8)
#define HSAHW9(x) (x+9)
#define HSAHW10(x) (x+10)
#define HSAHW11(x) (x+11)
#define HSAHW12(x) (x+12)
#define HSAHW13(x) (x+13)
#define HSAHW14(x) (x+14)
#define HSAHW15(x) (x+15)
#define CONTROLW(x) (x+16)

#define HASHR0(x) (x)
#define HASHR1(x) (x+1)
#define HASHR2(x) (x+2)
#define HASHR3(x) (x+3)
#define HASHR4(x) (x+4)
#define HASHR5(x) (x+5)
#define HASHR6(x) (x+6)
#define HASHR7(x) (x+7)
#define HASHR8(x) (x+8)

struct acc_dev {
    struct resource res; /* Resource: our registers */
    void __iomem *virtbase; /* Where registers can be accessed in memory */
    hashi_t hash_input;
} dev;

static void write_hash(hashi_t * hash_input)
{
    iowrite32(hash_input->i0, HASHW0(dev.virtbase));
    iowrite32(hash_input->i1, HASHW1(dev.virtbase));
    iowrite32(hash_input->i2, HSAHW2(dev.virtbase));
    iowrite32(hash_input->i3, HSAHW3(dev.virtbase));
    iowrite32(hash_input->i4, HSAHW4(dev.virtbase));
    iowrite32(hash_input->i5, HSAHW5(dev.virtbase));
    iowrite32(hash_input->i6, HSAHW6(dev.virtbase));
    iowrite32(hash_input->i7, HSAHW7(dev.virtbase));
    iowrite32(hash_input->i8, HSAHW8(dev.virtbase));
    iowrite32(hash_input->i9, HSAHW9(dev.virtbase));
    iowrite32(hash_input->i10, HSAHW10(dev.virtbase));
    iowrite32(hash_input->i11, HSAHW11(dev.virtbase));
    iowrite32(hash_input->i12, HSAHW12(dev.virtbase));
    iowrite32(hash_input->i13, HSAHW13(dev.virtbase));
    iowrite32(hash_input->i14, HSAHW14(dev.virtbase));
    iowrite32(hash_input->i15, HSAHW15(dev.virtbase));
    dev.hash_input = *hash_input;
}

static void read_hash(hasho_t * hash_output)
{
    hash_output->o0 = ioread32(HASHR0(dev.virtbase));
    hash_output->o1 = ioread32(HASHR1(dev.virtbase));
    hash_output->o2 = ioread32(HASHR2(dev.virtbase));
    hash_output->o3 = ioread32(HASHR3(dev.virtbase));
    hash_output->o4 = ioread32(HASHR4(dev.virtbase));
    hash_output->o5 = ioread32(HASHR5(dev.virtbase));
    hash_output->o6 = ioread32(HASHR6(dev.virtbase));
    hash_output->o7 = ioread32(HASHR7(dev.virtbase));
    hash_output->o8 = ioread32(HASHR8(dev.virtbase)); // handshake signal
}

static long acc_ioctl(struct file *f, unsigned int cmd, hashi_arg_t arg)
{
    hashi_t hash_input;
    hasho_t hash_output;

    switch (cmd) {
    case ACC_WRITE_HASH:
        if (copy_from_user(&hash_input, (hashi_t *) arg, sizeof(hashi_t)))
            return -EACCES;
        write_hash(&hash_input);
        iowrite32(0xffffffff, CONTROLW(dev.virtbase));
        break;
    /* Useless */
    case ACC_READ_HASH:
        read_hash(&hash_output);
        if (copy_to_user((hasho_t *) arg, &hash_output, sizeof(hasho_t)))
            return -EACCES;
        break;
    default:
        return -EINVAL;
    }
    return 0;
}

static const struct file_operations acc_fops = {
    .owner = THIS_MODULE,
    .unlocked_ioctl = acc_ioctl,
};

static struct miscdevice acc_miscdev = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = DRIVER_NAME,
    .fops = &acc_fops,
};

static int __init acc_probe(struct platform_device *pdev)
{
    hashi_t beigh = {0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000};
}