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

#define HASHR0(x) (x)
#define HASHR1(x) (x+1)
#define HASHR2(x) (x+2)
#define HASHR3(x) (x+3)
#define HASHR4(x) (x+4)
#define HASHR5(x) (x+5)
#define HASHR6(x) (x+6)
#define HASHR7(x) (x+7)
#define HASHR8(x) (x+8)

#define CONTROLW(x) (x+16) // write only: sw -> hw
#define CONTROLR(x) (x+17) // read only: hw -> sw

struct acc_dev {
    struct resource res; /* Resource: our registers */
    void __iomem *virtbase; /* Where registers can be accessed in memory */
    registers_t registers;
    control_signal_t control_signal;
} dev;

static void write_hash(registers_t * hash_input)
{
    iowrite32(hash_input->r0, HASHW0(dev.virtbase));
    iowrite32(hash_input->r1, HASHW1(dev.virtbase));
    iowrite32(hash_input->r2, HSAHW2(dev.virtbase));
    iowrite32(hash_input->r3, HSAHW3(dev.virtbase));
    iowrite32(hash_input->r4, HSAHW4(dev.virtbase));
    iowrite32(hash_input->r5, HSAHW5(dev.virtbase));
    iowrite32(hash_input->r6, HSAHW6(dev.virtbase));
    iowrite32(hash_input->r7, HSAHW7(dev.virtbase));
    iowrite32(hash_input->r8, HSAHW8(dev.virtbase));
    iowrite32(hash_input->r9, HSAHW9(dev.virtbase));
    iowrite32(hash_input->r10, HSAHW10(dev.virtbase));
    iowrite32(hash_input->r11, HSAHW11(dev.virtbase));
    iowrite32(hash_input->r12, HSAHW12(dev.virtbase));
    iowrite32(hash_input->r13, HSAHW13(dev.virtbase));
    iowrite32(hash_input->r14, HSAHW14(dev.virtbase));
    iowrite32(hash_input->r15, HSAHW15(dev.virtbase));
    dev.registers = *hash_input;
}

static void read_hash(registers_t * hash_output)
{
    hash_output->r0 = ioread32(HASHR0(dev.virtbase));
    hash_output->r1 = ioread32(HASHR1(dev.virtbase));
    hash_output->r2 = ioread32(HASHR2(dev.virtbase));
    hash_output->r3 = ioread32(HASHR3(dev.virtbase));
    hash_output->r4 = ioread32(HASHR4(dev.virtbase));
    hash_output->r5 = ioread32(HASHR5(dev.virtbase));
    hash_output->r6 = ioread32(HASHR6(dev.virtbase));
    hash_output->r7 = ioread32(HASHR7(dev.virtbase));
    hash_output->r8 = ioread32(HASHR8(dev.virtbase)); // handshake signal
}

static void write_start(unsined int control)
{
    iowrite32(control, CONTROLW(dev.virtbase));
}

static void read_control(unsigned int *control)
{
    *control = ioread32(CONTROLR(dev.virtbase));
}

static long acc_ioctl(struct file *f, unsigned int cmd, unsigned long arg)
{
    registers_arg_t vla;

    switch (cmd) {
    case ACC_WRITE_HASH:
        if (copy_from_user(&vla, (registers_arg_t *) arg, sizeof(registers_arg_t)))
            return -EACCES;
        write_hash(&vla.registers);
        write_control(0xffffffff); //start flag
        break;
    /* Useless */
    case ACC_READ_HASH:
        vla.registers = dev.registers;
        if (copy_to_user((registers_arg_t *) arg, &vla, sizeof(registers_arg_t)))
            return -EACCES;
        break;
    case CONTROL_READ:
        vla.control_signal = dev.control_signal;
        if(copy_to_user((registers_arg_t* arg, &vla, sizeof(registers_arg_t) )))
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

static struct miscdevice acc_misc_dev = {
    .minor = MISC_DYNAMIC_MINOR,
    .name = DRIVER_NAME,
    .fops = &acc_fops,
};

static int __init acc_probe(struct platform_device *pdev)
{
    register beigh = {0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000,
    0x00000000, 0x00000000, 0x00000000, 0x00000000};

    int ret;

    ret = misc_register(&acc_misc_dev);

    ret = of_address_to_resource(pdev->dev.of_node, 0, &dev.res);
    if(ret){
        ret = -ENODEV;
        goto out_deregister;
    }

    if (request_mem_region(dev.res.start, resource_size(&dev.res),
			       DRIVER_NAME) == NULL) {
		ret = -EBUSY;
		goto out_deregister;
	}

    dev.virtbase = ioremap(dev.res.start, resource_size(&dev.res));
    if (dev.virtbase == NULL) {
        ret = -ENOMEM;
        goto out_release_mem;
    }

    write_hash(&beigh);
    // iowrite32(0x00000000, CONTROLW(dev.virtbase));

    return 0;

out_release_mem:
    release_mem_region(dev.res.start, resource_size(&dev.res));
out_deregister:
    misc_deregister(&acc_misc_dev);
    return ret;
}

static int acc_remove(struct platform_device *pdev)
{
    iounmap(dev.virtbase);
    release_mem_region(dev.res.start, resource_size(&dev.res));
    misc_deregister(&acc_misc_dev);
    return 0;
}

#ifdef CONFIG_OF
static const struct of_device_id acc_of_match[] = {
	{ .compatible = "csee4840,acc-1.0" },
	{},
};
MODULE_DEVICE_TABLE(of, acc_of_match);
#endif

static struct platform_driver acc_driver = {
    .driver = {
        .name = DRIVER_NAME,
        .owner = THIS_MODULE,
        .of_match_table = of_match_ptr(acc_of_match),
    },
    // .probe = acc_probe,
    .remove = __exit_p(acc_remove),
};

static int __init acc_init(void)
{
    return platform_driver_probe(&acc_driver, acc_probe);
}

static void __exit acc_exit(void)
{
    platform_driver_unregister(&acc_driver);
    pr_info(DRIVER_NAME ": exit\n");
}

module init(acc_init);
module exit(acc_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("mgy");
MODULE_DESCRIPTION("SHA256 Accelerator Driver");